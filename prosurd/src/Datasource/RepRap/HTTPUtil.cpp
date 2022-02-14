#include "HTTPUtil.hpp"

#include <unistd.h>

#include <iostream>
#include <string>

#include "curl/curl.h"

#include <Datasource/RepRap/HTTPUtil.hpp>
#include <Util/Util.hpp>
#include "Main.hpp"

using namespace std;

namespace Prosur::Datasource::RepRap::HTTPUtil{

	bool ready = false;

	static size_t onReceiveData(void* contents, size_t size, size_t nmemb, string* s){
		size_t newLength = size*nmemb;
		try{
			s->append((char*)contents, newLength);
		}catch(bad_alloc &e){
			return 0;
		}
		return newLength;
	}

	string call(string url){
		if(!ready){
			ready = true;
			curl_global_init(CURL_GLOBAL_DEFAULT);
		}

		const int MAX_ATTEMPT = 10;
		for(int attempt = 0; attempt < MAX_ATTEMPT; attempt++){

			string receiveBuffer;
			CURL* curl = curl_easy_init();
			if(!curl){
				log("HTTPUtil: Warning: call: curl init failed. Attempt " + to_string(attempt+1) + "/" + to_string(MAX_ATTEMPT) + ".");
				curl_easy_cleanup(curl);
				usleep(1000 * 100);
				continue;
			}

			curl_easy_setopt(curl, CURLOPT_URL, url.c_str());
			curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, onReceiveData);
			curl_easy_setopt(curl, CURLOPT_WRITEDATA, &receiveBuffer);
			curl_easy_setopt(curl, CURLOPT_VERBOSE, 0L);
			curl_easy_setopt(curl, CURLOPT_FAILONERROR, 1L);

			CURLcode res = curl_easy_perform(curl);

			if(res != CURLE_OK){
				long http_code = 0;
				curl_easy_getinfo(curl, CURLINFO_RESPONSE_CODE, &http_code);
				log("HTTPUtil: call: curl_easy_perform() failed: " + string(curl_easy_strerror(res)) + ". Attempt " + to_string(attempt+1) + "/" + to_string(MAX_ATTEMPT));
				log(". HTTP status: " + to_string(http_code));
				log(". HTTP Response: " + receiveBuffer);
				log(" Request URL: " + url + ".");
				usleep(1000 * 100);
				continue;
			}

			return receiveBuffer;
		}

		log("HTTPUtil: Giving up after " + to_string(MAX_ATTEMPT) + " failures.");
		terminate();
	}
}
