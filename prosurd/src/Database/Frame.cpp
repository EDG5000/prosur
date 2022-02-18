#include "Database/Frame.hpp"

#include "Database/DBValue.hpp"
#include "Log.hpp"

#include <map>
#include <vector>

using namespace std;

namespace Prosur::Database{
	// Used when inserting frame into database and when printing error to log
	void Frame::exportMap(map<string, DBValue>& values){
		// Create map of DBValues for insertion into frame table
		values = {
			{"time", time},
			{"job_id", isPrinting ? jobId : INT32_MAX},
			{"job_file_name", jobFilename}
		};

		// Add still images to map
		for(int i = 0; i < still.size(); i++){
			values["still_" + to_string(i)] = still[i];
		}

		// Add aux temperatures to map
		for(int i = 0; i < auxTemp.size(); i++){
			values["temp_aux_" + to_string(i)] = auxTemp[i];
		}

		// Add heater temperatures to map
		for(int i = 0; i < heaterTemp.size(); i++){
			values["temp_heater_" + to_string(i)] = heaterTemp[i];
		}

		// Voltage and temperatures per board; add to map
		for(int i = 0; i < cpuTemp.size(); i++){
			values["temp_cpu_" + to_string(i)] = cpuTemp[i];
			values["vin_" + to_string(i)] = cpuTemp[i];
		}

		// Motor positions
		for(int i = 0; i < motorPos.size(); i++){
			values["pos_motor_" + to_string(i)] = motorPos[i];
		}

		// Endstop positions
		for(int i = 0; i < endstop.size(); i++){
			values["endstop_" + to_string(i)] = endstop[i];
		}

		// Probe positions
		for(int i = 0; i < probe.size(); i++){
			values["probe_" + to_string(i)] = probe[i];
		}

		// Coincidentally, the following lines ended up being sorted by length
		values["speed_current_mms"] = speedCurrentMms;
		values["speed_requested_mms"] = speedRequestedMms;
		values["print_layers_printed"] = printLayersPrinted;
		values["print_layers_total"] = printLayersTotal;
		values["print_progress_percentage"] = printProgressPercentage;
	}

	string Frame::toString(){
		map<string, DBValue> values;
		exportMap(values);
		string retVal;
		for(auto& [key, value]: values){
			retVal += key + ": " + value.toString() + "\n";
		}
		return retVal;
	}
}
