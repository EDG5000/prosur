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

json om;

constexpr int temp_sensor_count = 3;

// Blocking update call. Return within 250ms. Suggest calling at 1Hz.
void update(){
	httplib::Client client("http://192.168.2.15");
	auto response = client.Get("rr_model?flags=d99fn");
	if(response->status != 200){
		cout << "Got HTTP" << response->status << endl;
		return;
	}

	om = json::parse(response->body);
	std::cout << om.dump();
	//temp[0-2] = result.heat.heaters[0-2].current
	//isPrinting = result.job.build == null
	//result.file.fileName
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
	vector<float> temperatures(temp_sensor_count);
	try{
		json json_heaters = om["heat"]["heaters"];
		for(int temp_index = 0; temp_index < temp_sensor_count; temp_index++){
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
