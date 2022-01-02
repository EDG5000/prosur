#include <Datasource/RepRap/HTTPUtil.hpp>
#include <Util/Util.hpp>
#include <iostream>
#include <string>
#include "curl/curl.h"


using namespace std;

namespace Prosur::Datasource::RepRap::HTTPUtil{

	static size_t onReceiveData(void *contents, size_t size, size_t nmemb, std::string *s){
		size_t newLength = size*nmemb;
		try{
			s->append((char*)contents, newLength);
		}catch(std::bad_alloc &e){
			return 0;
		}
		return newLength;
	}


	// TODO consider performance; can downloaded job files be streamed directly into the database?
	string call(string url){
		curl_global_init(CURL_GLOBAL_DEFAULT);

		string receiveBuffer;
		CURL* curl = curl_easy_init();
		if(!curl){
			cerr << "HTTPUtil: call: curl init failed" << endl;
			curl_easy_cleanup(curl);
			return "";
		}

		curl_easy_setopt(curl, CURLOPT_URL, url.c_str());
		curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, onReceiveData);
		curl_easy_setopt(curl, CURLOPT_WRITEDATA, &receiveBuffer);
		curl_easy_setopt(curl, CURLOPT_VERBOSE, 0L); //remove this to disable verbose output
		curl_easy_setopt(curl, CURLOPT_FAILONERROR, 1L);

		CURLcode res = curl_easy_perform(curl);
		if(res != CURLE_OK){
			cerr << "HTTPUtil: call: curl_easy_perform() failed: " << curl_easy_strerror(res) << endl;
			return "";
		}

		curl_global_cleanup();

		return receiveBuffer;
	}

}
