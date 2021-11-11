#include "rrfclient.hpp"

#include <vector>
#include <iostream>
#include <string>
#include "curl/curl.h"
#include "json.hpp"

#include "util.hpp"

using namespace std;
using namespace nlohmann;

namespace rrfclient{

//http://192.168.2.15/rr_connect?password=amirgay0511&time=2021-11-8T18:9:31
// rr_connect?password=XXX&time=YYY
// or: //http://192.168.2.15/rr_model?flags=d99fn
//rr_model?flags=d99fn
// http://192.168.2.15/rr_download?name=0:/gcodes/CFFFP_Electronics Box.gcode

// Get filename of currently printed file:
// result.file.fileName
//http://theseus3.local/rr_model?key=job&flags=d99vn

json om;

const int TEMP_SENSOR_COUNT = 3;
const string RR_BASE_URL = "http://theseus3.local/";
const string FLAGS_STATUS = "d99fn";
const string FLAGS_JOB = "d99vn";
const string KEY_JOB = "job";
const string ACTION_MODEL = "rr_model";


size_t onReceiveData(void *contents, size_t size, size_t nmemb, std::string *s){
    size_t newLength = size*nmemb;
    try{
        s->append((char*)contents, newLength);
    }catch(std::bad_alloc &e){
        return 0;
    }
    return newLength;
}

// Call RR API
json call(string action, string flags, string key = ""){
	// Form url
	string url = RR_BASE_URL + action + "?flags=" + flags;
	if(key.size() > 0){
		url += "&key=" + key;
	}

	CURL *curl;
	CURLcode res;
	string receiveBuffer;

	curl_global_init(CURL_GLOBAL_DEFAULT);

	curl = curl_easy_init();
	if(!curl){
		cerr << "curl init failed" << endl;
		curl_easy_cleanup(curl);
		return json();
	}
	curl_easy_setopt(curl, CURLOPT_URL, url.c_str());
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, onReceiveData);
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, &receiveBuffer);
    curl_easy_setopt(curl, CURLOPT_VERBOSE, 0L); //remove this to disable verbose output
    curl_easy_setopt(curl, CURLOPT_FAILONERROR, 1L);

	res = curl_easy_perform(curl);
	if(res != CURLE_OK){
		cerr << "rrfclient: call: curl_easy_perform() failed: " << curl_easy_strerror(res) << endl;
		return json();
	}

	curl_global_cleanup();

	try{
		return json::parse(receiveBuffer);
	}catch(const json::exception& e){
		cerr << "rrfclient: exception while parsing body in call(): " << e.what() << endl;
		return json();
	}
}

// Blocking update call. Return within 250ms. Suggest calling at 1Hz.
bool update(){
	// Get base status object and store in om
	json om_status = call(ACTION_MODEL, FLAGS_STATUS);
	if(om_status.is_null()){
		cerr << "rffclient: unable to retrieve om_status, skipping update cycle." << endl;
		return false;
	}
	om = om_status;

	cout << om.dump() << endl;

	// Perform extra request to get information about current print
	if(get_is_printing()){
		json om_job = call(ACTION_MODEL, FLAGS_JOB, KEY_JOB);
		if(om_job.is_null()){
			cerr << "rffclient: unable to retrieve om_job, skipping further processing." << endl;
			return false;
		}
		// Merge the two objects
		try {
			cout << om_job.dump() << endl;
			om["result"]["file"] = om_job["result"]["file"];
			cout << om.dump() << endl;
		}catch(const json::exception& e){
			cerr << "rrfclient: unable to merge job; skipping further processing << endl;";
			return false;
		}
	}

	return true;
}

bool get_is_printing(){
	try{
		return om["job"]["build"].is_null();
	}catch(json::exception& e){
		cerr << "rrfclient: get_is_printing: error accessing om: " << e.what() << endl;
		return false;
	}
}

vector<float> get_temperatures(){
	vector<float> temperatures(TEMP_SENSOR_COUNT);
	try{
		json json_heaters = om["heat"]["heaters"];
		for(int temp_index = 0; temp_index < TEMP_SENSOR_COUNT; temp_index++){
			temperatures[temp_index] = json_heaters[temp_index]["current"];
		}
	}catch(json::exception& e){
		cout << "rrfclient: get_temperatures: error accessing om: " << e.what() << endl;
	}
	return temperatures;
}

string get_filename(){
	try{
		return om["file"]["fileName"];
	}catch(json::exception& e){
		cerr << "rrfclient: get_filename: error accessing om: " << e.what() << endl;
		return "";
	}
}

}
