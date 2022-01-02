#include <Datasource/RepRap/HTTPUtil.hpp>
#include <Datasource/RepRap/RepRap.hpp>
#include <vector>
#include <iostream>
#include <string>
#include <time.h>

#include "curl/curl.h"
#include "json.hpp"

#include <Util/Util.hpp>
#include "Database/Database.hpp"

using namespace std;
using namespace nlohmann;

namespace Prosur::Datasource::RepRap{

	const int TEMP_SENSOR_COUNT = 3;
	const string RR_BASE_URL = "http://theseus3.local/";
	const string FLAGS_STATUS = "d99fn";
	const string FLAGS_JOB = "d99vn";
	const string KEY_JOB = "job";

	// Call RR API
	static json downloadModel(string flags, string key = ""){
		// Form url
		string url = RR_BASE_URL + "rr_model?flags=" + flags;
		if(key != ""){
			url += "&key=" + key;
		}
		string receiveBuffer = HTTPUtil::call(url);
		if(receiveBuffer == ""){
			cerr << "RepRapClient: downloadModel: HTTPUtil::call returned empty string." << endl;
			terminate();
			return json();
		}
		try{
			return json::parse(receiveBuffer);
		}catch(const json::exception& e){
			cerr << "RepRapClient: exception while parsing body in call(): " << e.what() << endl;
			return json();
		}
	}

	// Blocking update call.
	// Will download the current job's file when transitioning into printing state.
	void fillFrame(Database::Frame& frame){

		// Download base status object and store in om
		json om = downloadModel(FLAGS_STATUS);
		if(om.is_null()){
			cerr << "rffclient: unable to retrieve om_status, skipping update cycle." << endl;
			terminate();
		}

		// Fetch printing state
		try{
			frame.isPrinting = !om["job"]["build"].is_null();
		}catch(json::exception& e){
			cerr << "RepRapClient: fillFrame: unable to value for isPrinting state from om: " << e.what() << endl;
			terminate();
		}

		// When printing, download and merge job model to get information about current print
		if(frame.isPrinting){
			json om_job = downloadModel(FLAGS_JOB, KEY_JOB);
			if(om_job.is_null()){
				cerr << "rffclient: unable to retrieve om_job, skipping further processing." << endl;
				terminate();
			}
			// Merge the two objects
			try {
				om["result"]["file"] = om_job["result"]["file"];
			}catch(const json::exception& e){
				cerr << "RepRapClient: unable to merge om: " << om.dump() << " with om_job: " << om_job.dump();
				terminate();
			}
		}

		// Access the downloaded model; store relevant values in the Frame
		try{
			// Job file metadata
			frame.jobFilename = om["result"]["file"]["fileName"];
			frame.jobFileModified = Util::parseDateTimeString(om["result"]["file"]["lastModified"]);

			// Heater temperatures
			for(int i = 0; i < om["heat"]["heaters"].size(); i++){
				frame.heaterTemp[i] = om["heat"]["heaters"][i]["current"];
			}

			// Board input voltage and CPU temp
			for(int i = 0; i < om["result"]["boards"].size(); i++){
				frame.inputVoltage[i] = om["result"]["boards"][i]["vIn"]["current"];
				frame.cpuTemp[i] = om["result"]["boards"][i]["mcuTemp"]["current"];
			}

			// Motor positions, including extruder
			for(int i = 0; i < 3; i++){
				frame.motorPos[i] = om["result"]["mode"]["axes"][0]["machinePosition"];
			}
			frame.motorPos[3] = om["result"]["move"]["extruders"][0]["position"];
		}catch(json::exception& e){
			cerr << "RepRapClient: fillFrame: error accessing object model: " << e.what() << endl;
			terminate();
		}

		// When in transitioning to printing state, download current job file.
		if(frame.isPrinting && !frame.wasPrinting){
			string filename = frame.jobFilename;
			if(filename == ""){
				cerr << "RepRapClient: error: get_current_job_filename returned an empty string. unable to download job file" << endl;
				terminate();
			}
			string fileData = HTTPUtil::call(RR_BASE_URL + "rr_download&name=" + filename); // TODO is this the correct URL? Please test your work Joel...
			frame.jobFile.assign(fileData.begin(), fileData.end());
		}

		terminate();
	}
}
