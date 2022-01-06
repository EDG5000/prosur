#include <Datasource/RepRap/HTTPUtil.hpp>
#include <Datasource/RepRap/RepRap.hpp>
#include <vector>
#include <iostream>
#include <string>
#include <time.h>

#include "curl/curl.h"
#include "json.hpp"

#include <Util/Util.hpp>
#include "Database/Frame.hpp"
#include "JobFile/JobFile.hpp"

using namespace std;
using namespace nlohmann;

namespace Prosur::Datasource::RepRap{

	const int TEMP_SENSOR_COUNT = 3;
	const string RR_BASE_URL = "http://theseus3.local/";
	const string FLAGS_STATUS = "d99fn";
	const string FLAGS_JOB = "d99vn";
	const string KEY_JOB = "job";

	vector<string> lastKeysChecked; // Used in some of the error logging scenarios

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

	// Check chain of keys to be present in json object one by one.
	// nlohman::json exceptions don't give details obout errors when expected keys are missing.
	// By examining the problematic json payload, it can be determined where the error is,
	// however, troubleshooting is easier when we print where the actual error is.
	// TODO there has to be a more elegant way to retrieve multiple JSON properties and report errors in detail.
	static void checkKeys(json& obj, const vector<string> keys){
		lastKeysChecked = keys;
		json curObj = obj; // We are copying data here; using a reference here was causing issues during testing, with the json argument to this function being modified
		for(int keyIndex = 0; keyIndex < keys.size(); keyIndex++){
			if(!curObj.contains(keys[keyIndex])){
				string error = "RepRap: Key was not found in object: " + obj.dump(4) + " keys: ";
				// Add keys before and including current key to error string
				for(int i = 0; i < (keyIndex+1); i++){
					error += "." + keys[i];
				}
				cerr << error << endl;
				terminate();
			}
			// Set object reference to be used next iteration
			// TODO this is copying data due to curObj not being a reference. See note next to curObj declaration.
			curObj = curObj[keys[keyIndex]];
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
		checkKeys(om, {"result", "job", "build"});
		try{
			frame.isPrinting = !om["result"]["job"]["build"].is_null();
		}catch(json::exception& e){
			cerr << "RepRapClient: fillFrame: unable to value for isPrinting state from om: " << e.what() << endl;
			terminate();
		}


		// Access the downloaded model; store relevant values in the Frame
		// TODO The key checking and complicated error reporting code makes this piece less elegant than originally intended.
		try{
			// When printing, download and merge job model to get information about current print
			if(frame.isPrinting){
				json om_job = downloadModel(FLAGS_JOB, KEY_JOB);
				if(om_job.is_null()){
					cerr << "rffclient: unable to retrieve om_job." << endl;
					terminate();
				}

				checkKeys(om_job, {"result", "file", "fileName"});
				if(om_job["result"]["file"]["fileName"].is_null()){
					// TODO Sometimes only lastFileName is available, so we use that one. It would be so much easier if fileName was simply included in the regular model. Are they any query parameters which can be added to avoid having to make a separate request to retrieve fileName?
					checkKeys(om_job, {"result", "lastFileName"});
					frame.jobFilename = om_job["result"]["lastFileName"];
				}else{
					frame.jobFilename = om_job["result"]["file"]["fileName"];
					frame.jobFileModified = Util::parseDateTimeString(om_job["result"]["file"]["lastModified"]);
				}

				checkKeys(om_job, {"result", "layer"});
				frame.printLayersPrinted = om_job["result"]["layer"];

				checkKeys(om_job, {"result", "file", "numLayers"});
				frame.printLayersTotal = om_job["result"]["file"]["numLayers"];
			}

			// Heater temperatures
			checkKeys(om, {"result", "heat", "heaters"});
			for(int i = 0; i < om["result"]["heat"]["heaters"].size(); i++){
				frame.heaterTemp.push_back(om["result"]["heat"]["heaters"][i]["current"]);
			}

			// Board input voltage and CPU temp
			checkKeys(om, {"result", "boards"});
			for(int i = 0; i < om["result"]["boards"].size(); i++){
				checkKeys(om["result"]["boards"][i], {"vIn", "current"});
				frame.inputVoltage.push_back(om["result"]["boards"][i]["vIn"]["current"]);
				frame.cpuTemp.push_back(om["result"]["boards"][i]["mcuTemp"]["current"]);
			}

			// Motor positions, including extruder
			checkKeys(om, {"result", "move", "axes"});
			for(int i = 0; i < 3; i++){
				checkKeys(om["result"]["move"]["axes"][i], {"machinePosition"});
				frame.motorPos.push_back(om["result"]["move"]["axes"][i]["machinePosition"]);
			}
			checkKeys(om, {"result", "move", "extruders"});
			frame.motorPos.push_back(om["result"]["move"]["extruders"][0]["position"]);

			// Endstops
			checkKeys(om, {"result", "sensors", "endstops"});
			for(int i = 0; i < om["result"]["sensors"]["endstops"].size(); i++){
				checkKeys(om["result"]["sensors"]["endstops"][i], {"triggered"});
				frame.endstop.push_back(om["result"]["sensors"]["endstops"][i]["triggered"] ? 1 : 0);
			}

			// Probes
			checkKeys(om, {"result", "sensors", "probes"});
			for(int i = 0; i < om["result"]["sensors"]["probes"].size(); i++){
				checkKeys(om["result"]["sensors"]["probes"][i], {"value"});
				frame.probe.push_back(om["result"]["sensors"]["probes"][i]["value"][0]); // Probes with multiple values will only have value 0 stored.
			}
		}catch(json::exception& e){
			cerr << "RepRapClient: fillFrame: error: " << e.what() << " while accessing object model: " << om.dump(4) << " frame: " << frame.toString() << " keys accessed: " << Util::join(lastKeysChecked, ".") << endl;
			terminate();
		}

		// When transitioning to printing state, download current job file.
		// Also parse the job file and extract any print parameters
		if(frame.isPrinting && !frame.wasPrinting){
			string filename = frame.jobFilename;
			if(filename == ""){
				cerr << "RepRapClient: error: get_current_job_filename returned an empty string. unable to download job file" << endl;
				terminate();
			}
			string fileData = HTTPUtil::call(RR_BASE_URL + "rr_gcode?"  + Util::encodeURIComponent("gcode=M37 P\"0:/gcodes/" + filename + "\""));
			frame.jobFile.assign(fileData.begin(), fileData.end());
			frame.jobParameters = JobFile::extractParameters(fileData);
		}
	}
}
