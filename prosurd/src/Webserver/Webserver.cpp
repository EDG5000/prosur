/*
 * WARNING: Only run this behing NAT on a network where all machines are fully trusted.
 *
 * If the network and all devices connected to it are not considered fully trused, consider closing port 80 using local firewall
 * And using an SSH tunnel to access port 80 on the remote machine. Or, just YOLO it.
 *
 * This is free software; see the source for copying conditions.  There is NO
 * warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 */

/*
 * Webserver: Listen for HTTP GET requests on TCP port 8080.
 * Respond to requests by invoking the relevant resource handler function.
 * URI Query parameters are passed to the resource handler for processing.
 */

#include "Webserver/Webserver.hpp"

#include <sys/types.h>
#include <sys/select.h>
#include <sys/stat.h>
#include <sys/socket.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <limits.h>
#include <signal.h>

#include <iostream>
#include <string>
#include <map>
#include <thread>

#include "Database/DBUtil.hpp"
#include "Util/Util.hpp"
#include <Webserver/Resources/Frames.hpp>
#include <Webserver/Resources/Jobs.hpp>
#include "Webserver/Resources/File.hpp"
#include "Webserver/Resources/Client.hpp"
#include "Webserver/Resources/Job.hpp"
#include "Webserver/HTTPResponseBody.hpp"
#include "Log.hpp"

using namespace std;

namespace Prosur::Webserver{

	constexpr int SERVER_PORT = 8080;
	constexpr int BUFSIZE = 4096;
	constexpr int SERVER_BACKLOG = 100;

	typedef struct sockaddr_in SA_IN;
	typedef struct sockaddr SA;

	//thread& thread;

	const map<int, string> STATUS_MESSAGE = {
		{HTTP::OK, "OK"},
		{HTTP::BAD_REQUEST, "Bad Request"},
		{HTTP::NOT_FOUND, "Not Found"},
		{HTTP::INTERNAL_SERVER_ERROR, "Internal Server Error"}
	};

	// Resources requested over HTTP are provided to the client by the relevant handler function
	// - The key is the resource/document/filename component of the URI.
	// - The map<string,string> argument contains query string parameters.
	// - Return type is HTTP status code.
	// - The response body has to be written either to the string argument or to the vector<char> argument.
	map<string, int(*)(string, HTTPResponseBody&, map<string,string>)> resourceHandlers = {
		{"", Resources::Client::run},
		{"main.js", Resources::Client::run},
		{"main.css", Resources::Client::run},
		{"jobs", Resources::Jobs::run}, // Default action (index). List all jobs.
		{"frames", Resources::Frames::run}, // Get all frames for given job_id or all frames between start and end time (includes frames when printer was idle)
		{"file", Resources::File::run}, // Download job file or still image taken at given frame ID
		{"job", Resources::Job::run} // Job print parameters
	};

	// Write response HTTP header and body with provided HTTP status code and response body
	static void sendResponse(int clientSocket, int httpCode, HTTPResponseBody responseBody){ // TODO Note: previously, responseBody was of reference-type to avoid copying.
		// Create response headers
		string responseHeader = "HTTP/1.1 " + to_string(httpCode) + " " + STATUS_MESSAGE.at(httpCode)+"\r\n" \
			"Access-Control-Allow-Origin: *\r\n" \
			"Content-Type: " + responseBody.type() + "\r\n\r\n";

		ssize_t bytesWritten;

		// Write response headers
		bytesWritten = write(clientSocket, responseHeader.c_str(), responseHeader.size());

		if(bytesWritten >= 0){
			// Send response body
			bytesWritten = write(clientSocket, responseBody, responseBody.size());
		}

		if(bytesWritten < 0){
			log("Webserver: Received error while writing response data: " + string(strerror(errno)));
			// TODO letting socket close after error. Is that the correct action?
		}

		// Close connection
		if(close(clientSocket) < 0){
			log("Webserver: Received error while closing socket: " + string(strerror(errno)));
		}
	}

	// Process incoming TCP connection; read and process HTTP request data
	static void handleConnection(int clientSocket){
		char buffer[BUFSIZE];
		ssize_t bytesRead = 0;
		int requestSize = 0;
		//char actualPath[PATH_MAX+1];
		bool initial = true;
		// TODO Implement timeout if no data is received?
		// TODO it is not waiting for EOF to detect end of HTTP request. Yet, it works fine! Perhaps this is by chance?
		while(initial || bytesRead > 0){
			initial = false;
			bytesRead = read(
				clientSocket, // fd
				(void*) (buffer + requestSize), // buf
				sizeof(buffer)-requestSize-1 // nbytes
			);
			if(bytesRead < 0){
				log("Webserver: Received error while reading request data: " + string(strerror(errno)));
				close(clientSocket); // TODO is this the right action, e.g. are we always in a position to close the socket or is the descriptor to be discarded and no operations are to be performed on it anymore?
				return;
			}
			requestSize += bytesRead;
			if(requestSize > BUFSIZE-1 || buffer[requestSize-1] == '\n'){
				break;
			}
		}

		// Request cannot be empty
		if(requestSize == 0){
			string error = "Webserver: Error: request size is 0, ignoring connection.";
			log(error);
			sendResponse(clientSocket, HTTP::BAD_REQUEST, error);
			return;
		}

		// Limit request size to 1000 bytes
		if(requestSize > 1000){
			string error = "Webserver: Error: request size exceeds 1000. Size: " + to_string(requestSize);
			log(error);
			sendResponse(clientSocket, HTTP::BAD_REQUEST, error);
			return;
		}

		// Create string from request buffer
		string requestData = string(buffer, requestSize);

		// Split header into lines, check for at least one line (HTTP status line)
		vector<string> headerLines = Util::strSplit(requestData, "\r\n");
		if(headerLines.size() == 0){
			string error = "Webserver: Request header line count expected to be at least 1. Request data: " + requestData ;
			log(error);
			sendResponse(clientSocket, HTTP::BAD_REQUEST, error);
			return;
		}

		// Parse HTTP status line
		string statusLine = headerLines[0];
		vector<string> statusComponents = Util::strSplit(statusLine, " ");
		if(statusComponents.size() != 3){
			string error = "Webserver: Expected request status line component count to be 3, Status line was: " + statusLine;
			log(error);
			sendResponse(clientSocket, HTTP::BAD_REQUEST, error);
			return;
		}

		// Parse URL to extract document name and query string (both optional)
		string url = statusComponents[1];

		//log(url);

		vector<string> urlSplit = Util::strSplit(url, "?");

		// Extract document name (may be empty) from URL
		string resourceName = urlSplit[0];
		Util::replaceAll(resourceName, "/", ""); // Remove preceding slash from URL

		// Parse query string, if present
		map<string, string> requestParameters;
		if(urlSplit.size() > 1){
			// Extract query string into requestParameters map
			string queryString = urlSplit[1];
			vector<string> pairs = Util::strSplit(queryString, "&");
			for(const string& pair: pairs){
				vector<string> pairElements = Util::strSplit(pair, "=");
				if(pairElements.size() != 2){
					string error = "Webserver: Error: Malformed URI. Pair element count expected to be 2. Source pair: " + pair + "Total URL: " + url;
					log(error);
					sendResponse(clientSocket, HTTP::BAD_REQUEST, error);
					return;
				}
				string key = pairElements[0];
				string value = pairElements[1];
				requestParameters[key] = value;
			}
		}

		// Detect non-existing document
		if(!resourceHandlers.contains(resourceName)){
			string error = "Webserver: Error: Resource not found: " + resourceName;
			log(error);
			sendResponse(clientSocket, HTTP::NOT_FOUND, error);
			return;
		}

		// Call appropriate resource handler to obtain response body and HTTP code
		HTTPResponseBody responseBody;
		int httpCode = resourceHandlers[resourceName](resourceName, responseBody, requestParameters);

		if(httpCode != HTTP::OK && httpCode != HTTP::NOT_FOUND){
			log("Webserver: Error while serving resource. URL: " + url);
		}

		// Respond
		sendResponse(clientSocket, httpCode, responseBody);
	}

	void init(){
		// Ignore SIGPIPE signals, triggered by the kernel when clients hang up connections early, which would cause the program to abort
		signal(SIGPIPE, SIG_IGN);

		// Start thread, listen for incoming connections
		// Invoke handleConnection for each connection
		// TODO handle requests in a separate thread for each request? What happens when multiple requests are received in rapid succession?
		//thread([]{
			// 1. Setup; get local address
			int addrSize;
			SA_IN serverAddr, clientAddr;
			serverAddr.sin_family = AF_INET;
			serverAddr.sin_addr.s_addr= INADDR_ANY;
			serverAddr.sin_port = htons(SERVER_PORT);

			// 2. Create socket
			int serverSocket = socket(AF_INET, SOCK_STREAM, 0);
			if(serverSocket < 0){
				log("Failed to create socket. Error code: " + string(strerror(errno)));
				terminate();
			}

			// Enable SO_REUSEADDR setting to disable socket reuse cooldown period
			int enable = 1;
			if(setsockopt(serverSocket, SOL_SOCKET, SO_REUSEADDR, &enable, sizeof(int)) < 0){
				log("Failed to enable SO_REUSEADDR. Error code: " + string(strerror(errno)));
				terminate();
			}

			// 3. Bind socket
			int result = bind(serverSocket, (SA*)&serverAddr, sizeof(serverAddr));
			if(result < 0){
				log("Webserver: Unable to bind to socket. Error code: " + string(strerror(errno)));
				terminate();
			}

			// 4. Start listening
			result = listen(serverSocket, SERVER_BACKLOG);
			if(result < 0){
				log("Webserver: Unable to listen to socket. Error code: " + string(strerror(errno)));
				terminate();
			}

			while(true){
				addrSize = sizeof(SA_IN);
				int clientSocket = accept(
					serverSocket, // fd
					(SA*) &clientAddr, // sockaddr
					(socklen_t*) &addrSize // socklen
				);
				// TODO Not sure if the thread here has any benefits. Seems to work fine without.
				thread([=]{
					handleConnection(clientSocket);
				}).detach();
			}
		//}).detach();
	}
}


