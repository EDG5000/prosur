#include "rrfclient.hpp"

#include <vector>
#include <iostream>
#include <string>

#include "httplib.hpp"
#include "json.hpp"

#include "util.hpp"

using namespace std;
using namespace nlohmann;

namespace rrfclient{

//http://192.168.2.15/rr_connect?password=amirgay0511&time=2021-11-8T18:9:31
// rr_connect?password=XXX&time=YYY
// or: //http://192.168.2.15/rr_model?flags=d99fn
// http://192.168.2.15/rr_download?name=0:/gcodes/CFFFP_Electronics Box.gcode

// Get filename of currently printed file:
// result.file.fileName
//http://theseus3.local/rr_model?key=job&flags=d99vn

json om;

const int TEMP_SENSOR_COUNT = 3;
const string RR_BASE_URL = "http://theseus3.local";
const string FLAGS_STATUS = "d99fn";
const string FLAGS_JOB = "d99vn";
const string KEY_JOB = "job";
const string ACTION_MODEL = "rr_model";

httplib::Client httpClient(RR_BASE_URL);

// Call RR API
json call(string action, string flags, string key = ""){
	string query = action + "flags=" + flags;
	if(key.size() > 0){
		action += "&key=" + key;
	}
	auto response = httpClient.Get(query.c_str());
	if(response->status != 200){
		cout << "Got HTTP" << response->status << endl;
		return json();
	}

	try{
		return json::parse(response->body);
	}catch(const json::exception& e){
		cout << "rrfclient: exception while parsing body in call(): " << e.what() << endl;
		return json();
	}
}

// Blocking update call. Return within 250ms. Suggest calling at 1Hz.
void update(){
	// Get base status object and store in om
	json om_status = call(ACTION_MODEL, FLAGS_STATUS);
	if(om_status.is_null()){
		cout << "rffclient: unable to retrieve om_status, skipping update cycle." << endl;
		return;
	}
	om = om_status;

	// Perform extra request to get information about current print
	if(get_is_printing()){
		json om_job = call(ACTION_MODEL, FLAGS_JOB, KEY_JOB);
		if(om_job.is_null()){
			cout << "rffclient: unable to retrieve om_job, skipping further processing." << endl;
			return;
		}
		// Merge the two objects
		try {
			om["file"] = om_job["file"];
		}catch(const json::exception& e){
			cout << "rrfclient: unable to merge job; skipping further processing << endl;";
			return;
		}
	}

	cout << om.dump() << endl;
}

bool get_is_printing(){
	try{
		return om["job"]["build"].is_null();
	}catch(json::exception& e){
		cout << "rrfclient: get_is_printing: error accessing om: " << e.what() << endl;
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
		cout << "rrfclient: get_filename: error accessing om: " << e.what() << endl;
		return "";
	}
}

}
