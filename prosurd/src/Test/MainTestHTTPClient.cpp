#include "HTTPClient/HTTPClient.hpp"

#include <unistd.h>

#include "Log.hpp"

namespace Prosur{

	string url = "http://172.217.168.206";

	extern "C" int main(){
		log("hallo");
		while(true){

			string response = HTTPClient::call(url);
			if(response == ""){
				log("Request failed.");
				continue;
			}
			log(to_string(response.size()));

			usleep(1000 * 1000 * 1);
		}
	}
}
