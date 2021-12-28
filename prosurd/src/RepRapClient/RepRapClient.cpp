#include <RepRapClient/RepRapClient.hpp>

#include <vector>
#include <iostream>
#include <string>
#include <time.h>

#include "curl/curl.h"
#include "json.hpp"

#include <Util/Util.hpp>

#include "RepRapClient/HTTPUtil.hpp"

using namespace std;
using namespace nlohmann;

namespace Prosur::RepRapClient{

const int TEMP_SENSOR_COUNT = 3;
const string RR_BASE_URL = "http://theseus3.local/";
const string FLAGS_STATUS = "d99fn";
const string FLAGS_JOB = "d99vn";
const string KEY_JOB = "job";

// Object model tree as returned by RepRapFirmware
json om;
json om_last; // Set to om from last frame
vector<char> lastJobFile; // Updated when transitioned to printing state from previous non-printing state (or when first frame after init is in printing state).

// Call RR API
json downloadModel(string flags, string key = ""){
	// Form url
	string url = RR_BASE_URL + "rr_model?flags=" + flags;
	if(key == ""){
		url += "&key=" + key;
	}
	string receiveBuffer = HTTPUtil::call(url);
	if(receiveBuffer == ""){
		return json();
	}
	try{
		return json::parse(receiveBuffer);
	}catch(const json::exception& e){
		cerr << "rrfclient: exception while parsing body in call(): " << e.what() << endl;
		return json();
	}
}

// Download a file and store it into lastJobFile
void downloadFile(string fileName){
	string url = RR_BASE_URL + "rr_download";
	// TODO consider streaming the data directly to postgres instead of storing and copying in memory
	// TODO how many copy operations are performed? What is the memory consumption for, say, a 200MB file?
	string fileData = HTTPUtil::call(url);
	lastJobFile.assign(fileData.begin(), fileData.end());
}

// Blocking update call.
// Will download the current job's file when transitioning into printing state.
bool update(){
	// Get base status object and store in om
	json om_status = downloadModel(FLAGS_STATUS);
	if(om_status.is_null()){
		cerr << "rffclient: unable to retrieve om_status, skipping update cycle." << endl;
		return false;
	}
	om_last = om;
	om = om_status;

	//cout << om.dump() << endl;

	// Perform extra request to get information about current print
	if(is_printing()){
		json om_job = downloadModel(FLAGS_JOB, KEY_JOB);
		if(om_job.is_null()){
			cerr << "rffclient: unable to retrieve om_job, skipping further processing." << endl;
			return false;
		}
		// Merge the two objects
		try {
			//cout << om_job.dump() << endl;
			om["result"]["file"] = om_job["result"]["file"];
			//cout << om.dump() << endl;
		}catch(const json::exception& e){
			cerr << "rrfclient: unable to merge job; skipping further processing << endl;";
			return false;
		}
	}

	// When in transition from non-printing to printing, Download current job file to memory.
	if(is_printing() && !was_printing()){
		// TODO evaluate performance
		string fileName = get_current_job_filename();
		if(fileName == ""){
			cerr << "rrfclient: error: get_filename returned an empty string. unable to download job file" << endl;
			return false;
		}
		downloadFile(fileName);
	}

	return true;
}

bool was_printing(){
	if(om_last.is_null()){
		// On first frame after initialisation, om_last is not instantiated yet.
		return false;
	}

	try{
		return om_last["job"]["build"].is_null();
	}catch(json::exception& e){
		cerr << "rrfclient: get_is_printing: error accessing last_om: " << e.what() << endl;
		return false;
	}
}

bool is_printing(){
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

string get_current_job_filename(){
	try{
		return om["result"]["file"]["fileName"];
	}catch(json::exception& e){
		cerr << "rrfclient: get_filename: error accessing om: " << e.what() << endl;
		return "";
	}
}

int64_t get_current_job_modified(){
	try{
		string datetimeString =  om["result"]["file"]["lastModified"];
		// 2021-07-25T23:25:34
		//
		tm datetime;
		memset(&datetime, 0, sizeof(datetime));
		char* result = strptime(datetimeString.c_str(), "%Y-%m-%dT%H:%M:%S", &datetime);
		if(result == NULL || *result != NULL){ // Should not be NULL and should point to the NUL byte at the end of the input string to mark a successfull full parse
			cerr << "Error, unable to parse date string: " << datetimeString << " (failed at character " << result-datetimeString.c_str() << *result << ")" << endl;
		}
		return mktime(&datetime);
	}catch(json::exception& e){
		cerr << "rrfclient: get_current_file_name: error accessing om: " << e.what() << endl;
		return -1;
	}
}

}
