#include "HTTPClient/HTTPClient.hpp"

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

#include "Log.hpp"

#define MAXLINE 4096
#define SA struct sockaddr
#define BUFSIZE 1024 * 1024 * 10 // 10Mb
using namespace std;

namespace Prosur::HTTPClient{

	// TODO add hostname support
	string call(string url){

		log("hallo");

		// Parse URL
		if(url.substr(0, 7) != "http://"){
			log("HTTPClient: Error: URL must begin with http://");
			return "";
		}
		url = url.substr(7);
		int firstSlashPosition = url.find("/");
		if(firstSlashPosition == string::npos){
			log("HTTPClient: URL path missing. Only URLs with path allowed.");
			return "";
		}
		string ipString = url.substr(0, firstSlashPosition);
		string urlPath = url.substr(firstSlashPosition);

		int sockfd, n;
		int sendbytes;
		struct sockaddr_in servaddr;

		// Create socket
		if((sockfd = socket(AF_INET, SOCK_STREAM, 0)) < 0){
			log("HTTPCLient: Error while opening socket: " + string(strerror(errno)));
			return "";
		}

		// Parse IP address
		bzero(&servaddr, sizeof(servaddr));
		servaddr.sin_family = AF_INET;
		servaddr.sin_port = htons(80);

		if(inet_pton(AF_INET, ipString.c_str(), &servaddr.sin_addr) <= 0){
			log("HTTPClient: Unable to parse IP address: " + ipString + " Error: " + string(strerror(errno)));
			return "";
		}

		// Connect
		if(connect(sockfd, (SA*) &servaddr, sizeof(servaddr)) < 0){
			log("HTTPCLient: Error while connecting to socket: " + string(strerror(errno)));
			return "";
		}

		// Assemble request
		string request = "GET " + urlPath + " HTTP/1.1\r\n\r\n";

		// Write data. When retry is needed, give up. Good connection expected.
		int bytesWritten = write(sockfd, request.c_str(), sendbytes) != request.size();
		if(bytesWritten != request.size()){
			log("HTTPClient: Error writing request. Bytes written: " + to_string(bytesWritten) + " Request size: " + to_string(request.size()) + " Error: " + string(strerror(errno)));
			return "";
		}

		char buffer[BUFSIZE];
		ssize_t bytesRead = 0;
		int requestSize = 0;
		//char actualPath[PATH_MAX+1];
		bool initial = true;
		// TODO Implement timeout if no data is received?
		while(initial || bytesRead > 0){
			initial = false;
			bytesRead = read(
				sockfd, // fd
				(void*) (buffer + requestSize), // buf
				sizeof(buffer)-requestSize-1 // nbytes
			);
			if(bytesRead < 0){
				log("HTTPClient: Received error while reading request data: " + string(strerror(errno)));
				close(sockfd); // TODO is this the right action, e.g. are we always in a position to close the socket or is the descriptor to be discarded and no operations are to be performed on it anymore?
				return "";
			}
			requestSize += bytesRead;
			if(requestSize > BUFSIZE-1 || buffer[requestSize-1] == '\n'){
				break;
			}
		}

		return string(buffer);
	}
}
