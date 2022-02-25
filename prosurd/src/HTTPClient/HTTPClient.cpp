#include <sys/socket.h>
#include <sys/types.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <stdarg.h>
#include <errno.h>
#include <fcntl.h>
#include <sys/time.h>
#include <sys/ioctl.h>
#include <netdb.h>
#include <string.h>

#include <string>
#include <iostream>

#include "Log.hpp"
#include "Util/Util.hpp"

using namespace std;

namespace Prosur::HTTPClient{

	// - Can only download strings using HTTP GET
	// - Allocates responses up to 1GB onto the heap
	// - Path or trailing slash mandatory
	// - Explicit port specifier disallowed
	// - Relies on remote server honoring the Connection: close header and closing the connection after sending response
	string call(string url){

		// Validate URL structure, extract hostname
		// Hostname itself only checked by DNS lookup later on
		if(url.substr(0, 7) != "http://"){
			log("HTTPClient: Error: URL must begin with http://. URL was: " + url);
			return "";
		}
		url = url.substr(7);
		if(url.find("/") == string::npos){
			log("HTTPClient: URL path missing. Only URLs with path allowed.");
			return "";
		}
		/*if(url.find(":") != string::npos){
			log("HTTPClient: Explicit port specifier not allowed in url: " + url);
			return "";
		}*/
		string hostname = url.substr(0, url.find("/"));
		url = url.substr(hostname.size());

		// Get protocol
		struct protoent* protoent = getprotobyname("tcp");
		if (protoent == NULL) {
			log("HTTPCLient: Error while obtaining TCP protocol reference: " + string(strerror(errno)));
			return "";
		}

		// Create socket
		int sockfd;
		if((sockfd = socket(AF_INET, SOCK_STREAM, protoent->p_proto)) < 0){
			log("HTTPCLient: Error while opening socket: " + string(strerror(errno)));
			return "";
		}

		// Resolve hostname
		struct hostent* remote_host = gethostbyname(hostname.c_str());
		if (remote_host == NULL) {
			log("HTTPCLient: Error while performing gethostbyname for hostname " + hostname + ": " + string(hstrerror(h_errno)));
			return "";
		}
		uint32_t remote_ip_addr = inet_addr(inet_ntoa(*(struct in_addr*)*(remote_host->h_addr_list)));
		if(remote_ip_addr == (in_addr_t)-1) {
			log("HTTPlient: Failed parsing string representation of address: " + string(*(remote_host->h_addr_list)) + ": " + string(strerror(errno)));
			return "";
		}

		// Setup socket address
		struct sockaddr_in remote_sock_addr;
		remote_sock_addr.sin_addr.s_addr = remote_ip_addr;
		remote_sock_addr.sin_family = AF_INET;
		uint16_t server_port = 80;
		remote_sock_addr.sin_port = htons(server_port);

		// Connect
		if(connect(sockfd, (struct sockaddr*) &remote_sock_addr, sizeof(remote_sock_addr)) < 0){
			log("HTTPCLient: Error while connecting to socket: " + string(strerror(errno)));
			return "";
		}

		// Create request
		// We are relying on remote server to hang up connection after sending response
		//string request = "GET " + url + " HTTP/1.1\r\nConnection: close\r\n\r\n";
		string request = "GET " + url + " HTTP/1.1\r\n\r\n";

		// Send request
		ssize_t nbytes_total = 0;
		ssize_t nbytes_last = 0;
		while (nbytes_total < request.size()) {
			nbytes_last = write(sockfd, request.c_str() + nbytes_total, request.size() - nbytes_total);
			if (nbytes_last == -1) {
				log("HTTPClient: Unable to write to socket. Total: "+to_string(nbytes_total)+ " Last: " + to_string(nbytes_last) + string(strerror(errno)));
				return "";
			}
			nbytes_total += nbytes_last;
		}

		// Read response
		string response;
		const int CHUNK_SIZE = 1024; // Up to 1K per read cycle
		const int MAX_RESPONSE = CHUNK_SIZE * 1024; // Prevent allocating responses beyond 1G
		char buffer[CHUNK_SIZE];
		while(true){
			// Read up to CHUNK_SIZE into buffer
			int bytesRead = read(sockfd, &buffer, CHUNK_SIZE);
			if(bytesRead < 0){
				log("HTTPClient: Received error while reading request data: " + string(strerror(errno)));
				if(close(sockfd) < 0){
					log("HTTPClient: Unable to close socket: " + string(strerror(errno)));
				}
				return "";
			}

			if(bytesRead == 0){
				break;
			}

			// Append to response string
			response += string(buffer, bytesRead);
		}
		if(close(sockfd) < 0){
			log("HTTPClient: Unable to close socket: " + string(strerror(errno)));
		}

		// Parse response into header lines, status line and response body. Check HTTP status.
		int headerEndPosition = response.find("\r\n\r\n");
		if(headerEndPosition == string::npos){
			log("HTTPClient: Error: Response does not contain the expected two newlines after the header. URL: " + url + " Response: " + response);
			return "";
		}
		string headerSection = response.substr(0, headerEndPosition);
		if(headerSection.size() == 0){
			log("HTTPClient: Error: Response contains empty header section. Response: " + response);
			return "";
		}
		vector<string> responseHeaders = Util::strSplit(headerSection, "\r\n");
		if(responseHeaders.size() == 0){
			log("HTTPClient: Error: Response contains no headers. Header section: " + headerSection);
			return "";
		}
		string statusLine = responseHeaders.at(0);
		vector<string> statusLineComponents = Util::strSplit(statusLine, " ");
		if(statusLineComponents.size() < 2){
			log("HTTPClient: Error: Response contains less than 2 status line components. Status line: " + statusLine);
			return "";
		}
		int status;
		try{
			status = stoi(statusLineComponents.at(1));
		}catch(exception& e){
			log("HTTPClient: Error: Unable to parse HTTP response code from string: " + statusLineComponents.at(0) + " Response: " + response);
			return "";
		}
		if(status != 200){
			log("HTTPClient: Error: Got HTTP error status of " + to_string(status) + ". URL: " + url + " Response: " + response);
			return "";
		}

		// Strip header section to leave only the response body
		response = response.substr(headerEndPosition + 4);

		return response;
	}

}
