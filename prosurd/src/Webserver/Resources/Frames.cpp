/*
 * Webserver Resource: Frames
 * Request a CSV file containing frames according to the parameters passed
 *
 * Query string:
 *
 * frames?mode=MODE[&min=MIN_TIME&max=MAX_TIME][&job_id=JOB_ID][&modulo=MODULO]
 *
 *MODE:
 *One of: latest|range|job
 *
 *  latest:
 *	Return latest frame. No parameters.
 *
 *	range:
 *	Return frames between MIN_TIME and MAX_TIME (inclusive, unix epoch seconds). Mandatory parameters.
 *
 *	job:
 *	Return al frames belonging to print job with matching JOB_ID. job_id parameter mandatory.
 *
 *MODULO:
 *Optional. Effectively reduces sampling rate. module=10 will reduce rate by 10, e.g. .1Hz will become .01Hz frame interval.
 */
#include <Webserver/Resources/Frames.hpp>

#include <iostream>
#include <string>
#include <map>

#include "Webserver/Webserver.hpp"
#include "Database/DBUtil.hpp"
#include "Webserver/HTTPResponseBody.hpp"
#include "json.hpp"

using namespace std;
using namespace nlohmann;

namespace Prosur::Webserver::Resources::Frames{

	enum Mode{
		Latest, // Return 1 frame, the latest frame
		Range, // Between min and max, inclusive
		Job // Show all frames by given job_id
	};

	const map<string, Mode> MODE_VALUES = {
		{"latest", Latest},
		{"range", Range},
		{"job", Job}
	};

	// List of mandatory parameters keyed by Mode
	const map<Mode, vector<string>> MANDATORY_PARAMETERS = {
			{Latest, {}},
			{Range, {"min", "max"}},
			{Job, {"job_id"}}
	};

	int run(HTTPResponseBody& responseBody, map<string,string> parameters){
cerr << "HALLO" << endl;
		// Check integer-params to be valid integers, when present. Store in map.
		vector<string> integerKeys = {"job_id", "start", "end", "modulus"};
		map<string, int> numericParameters;
		for(const auto& key: integerKeys){
			if(!parameters.contains(key)){
				continue;
			}
			try{
				numericParameters[key] = stoi(parameters[key]);
			}catch(const exception& e){
				responseBody = "Webserver: Error: "+key+" parameter is non-numeric. reason: " + string(e.what());
				cerr << responseBody << endl;
				return HTTP::BAD_REQUEST;
			}
			if(numericParameters[key] < 0){
				responseBody = "Webserver: Error: "+key+" parameter is lower than 0. Value: " + to_string(numericParameters[key]);
				cerr << responseBody << endl;
				return HTTP::BAD_REQUEST;
			}
		}

		// Validate the mode param, which is mandatory
		if(!parameters.contains("mode")){
			responseBody = "Webserver: Error: mode parameter not present, while it is mandatory.";
			cerr << responseBody << endl;
			return HTTP::BAD_REQUEST;
		}

		// Check if mode param is one of available options
		if(!MODE_VALUES.contains(parameters["mode"])){
			responseBody = "Webserver: Unknown mode selected: " + parameters["mode"];
			cerr << responseBody << endl;
			return HTTP::BAD_REQUEST;
		}

		// Assign Mode
		Mode mode = MODE_VALUES.at(parameters["mode"]);

		// Check for presence of available parameters based on selected Mode
		for(const auto& key: MANDATORY_PARAMETERS.at(mode)){
			if(!numericParameters.contains(key)){
				responseBody = "Webserver: Parameter " + key + " was not present, it is mandatory for the selected mode";
				cerr << responseBody << endl;
				return HTTP::BAD_REQUEST;
			}
		}

		// Obtain the optional modulus param. Modulus of 1 will have no effect.
		int modulus = 1;
		if(numericParameters.contains("modulus")){
			modulus = numericParameters["modulus"];
			if(modulus == 0){
				responseBody = "Webserver: Error: modulus parameter needs to be at least 1. Value: " + to_string(numericParameters["modulus"]);
				cerr << responseBody << endl;
				return HTTP::BAD_REQUEST;
			}
		}

		// Build frame retrieval query based on mode and parameters
		// TODO selecting * means also selecting the stills. This is too slow.
		string query = "select * from frame"; // Base query
		vector<Database::DBValue> queryParameters; // Empty param vector

		// Append to the query string and parameter vector depending on the selected mode
		switch(mode){
			case Latest:
				query += " order by time desc \
					limit 1";
				break;
			case Range:
				query += " where time > $1 and time < $2";
				queryParameters.push_back(numericParameters["min"]);
				queryParameters.push_back(numericParameters["max"]);
				if(modulus > 1){
					query += "  and time % $3 = 0";
					queryParameters.push_back(numericParameters["modulo"]);
				}
				break;
			case Job:
				query += " where job_id = $1";
				queryParameters.push_back(numericParameters["job_id"]);
				if(modulus > 1){
					query += "  and time % $2 = 0";
					queryParameters.push_back(numericParameters["modulo"]);
				}
				break;
		}

		// Run query to obtain frames
		auto frames = Database::DBUtil::query(query, queryParameters);

		// A job should at least have one frame
		if(frames.size() == 0){
			// Nothing do to; header cannot be constructed and no rows to serialize.
			string error = "Webserver: Frames: No data found for job_id: " + to_string(numericParameters["job_id"]);
			responseBody = error;
			cerr << error << endl;
			return HTTP::NOT_FOUND;
		}

		// Start preparing JSON object to return
		json outputObject;
		outputObject["frames"] = {};
		outputObject["parameters"] = {};

		// Write frames to the JSON object
		// TODO this is not working as auto-selecting the conversion is not working
		for(auto& row: frames){
			for(auto& [column, value]: row){
				cerr << value.toString() << endl;
				outputObject["frames"][column].push_back(value);
			}
		}

		// When in job mode, fetch job parameters and write to the JSON object
		if(mode == Job){ // key, value, job_id
			auto parameterRows = Database::DBUtil::query("\
				select * from job_parameter \
				where job_id = $1 \
			", {numericParameters["job_id"]});
			// Get job parameter key and value from each row, put in JSON object
			for(auto& row: parameterRows){
				if(!row.contains("key")){
					cerr << "Database::Resource::Frames: Missing column: key from output." << endl;
					terminate();
				}
				if(!row.contains("value")){
					cerr << "Database::Resource::Frames: Missing column: value from output." << endl;
					terminate();
				}
				cerr << (string) row["key"] << endl;
				cerr << (string) row["value"] << endl;
				outputObject[(string) row["key"]] = (string) row["value"];
			}
		}

		responseBody = outputObject;

		//
		/*
		// Build csv header
		bool first = true;
		for(auto& [key, value]: frames[0]){
			if(first){
				first = false;
				responseBody = key;
			}else{
				responseBody += "\t" + key;
			}
		}
		responseBody += "\n";

		// Append lines with tab-separated values
		for(auto& frame: frames){
			for(auto& [key, value]: frame){
				responseBody += value.toString() + "\t";
			}
			responseBody += "\n";
		}
*/

		return HTTP::OK;
	}
}
