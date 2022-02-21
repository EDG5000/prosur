#include "HTTPClient/HTTPClient.hpp"

#include <unistd.h>

#include "Log.hpp"

namespace Prosur{

	//string url = "http://google.com/";
	string url = "http://theseus3.local/";

	extern "C" int main(){
		while(true){

			string response = HTTPClient::call(url);
			if(response == ""){
				usleep(1000 * 1000 * 1);
				log("Request failed.");
				continue;
			}
			log(to_string(response.size()));

			usleep(1000 * 1000 * 1);
		}
	}
}
