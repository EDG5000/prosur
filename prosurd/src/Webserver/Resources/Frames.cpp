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
#include <set>

#include "Webserver/Webserver.hpp"
#include "Database/DBUtil.hpp"
#include "Database/Database.hpp"
#include "Webserver/HTTPResponseBody.hpp"
#include "json.hpp"
#include "Util/Util.hpp"

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
		// Check integer-params to be valid integers, when present. Store in map.
		vector<string> integerKeys = {"job_id", "min", "max", "modulus"};
		map<string, int64_t> numericParameters;
		for(const auto& key: integerKeys){
			if(!parameters.contains(key)){
				continue;
			}
			try{
				numericParameters[key] = stol(parameters[key]);
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

		// Retrieve user selection of columns
		vector<string> userSelectedColumns;
		if(parameters.contains("columns")){
			// Check the input for max size
			if(parameters["columns"].size() > 1000){
				responseBody = "Webserver: error: column parameter exceeded max length of 1000";
				cerr << responseBody << endl;
				return HTTP::BAD_REQUEST;
			}
			// Parse the parameter into a vector
			userSelectedColumns = Util::strSplit(parameters["columns"], ",");
			// Check each column for existance and disallow binary columns
			for(string& column: userSelectedColumns){
				if(!Database::frameColumnTypes.contains(column)){
					responseBody = "Webserver: Error: selected column does not exist in database: " + column;
					cerr << responseBody << endl;
					return HTTP::BAD_REQUEST;
				}
				if(Database::frameColumnTypes[column] == "text" || Database::frameColumnTypes[column] == "bytea"){
					responseBody = "Webserver: Error: selected column is not numeric: " + column;
					cerr << responseBody << endl;
					return HTTP::BAD_REQUEST;
				}
			}
		}

		// Holds selection of columns that will be used in the select query
		vector<string> finalColumnSelection;

		// Build list of columns to be included in select query
		for(auto& [column, type]: Database::frameColumnTypes){
			// Skip binary and text (used for gcode) columns to avoid slowdown
			if(type == "text" || type == "bytea"){
				continue;
			}

			// If user has specified a column list, check if it is on that list
			// TODO this lookup would be easier with a std::set
			if(userSelectedColumns.size() > 0){
				bool found = false;
				for(string& userColumn: userSelectedColumns){
					if(userColumn == column){
						found = true;
						break;
					}
				}
				if(!found){
					continue;
				}
			}

			finalColumnSelection.push_back(column);
		}

		string query = "select "+Util::join(finalColumnSelection, ",")+" from frame"; // Base query
		vector<Database::DBValue> queryParameters; // Empty param vector

		// Append to the query string and parameter vector depending on the selected mode
		switch(mode){
			case Latest:
				query += " order by time desc \
					limit 1";
				break;
			case Range:
				query += " where time >= $1::int8 and time <= $2::int8";
				queryParameters.push_back(numericParameters["min"]);
				queryParameters.push_back(numericParameters["max"]);
				if(modulus > 1){
					query += " and time % $3 = 0";
					queryParameters.push_back(numericParameters["modulus"]);
				}
				query += " order by time asc"; // Test data is sometimes ordered illogically
				break;
			case Job:
				query += " where job_id = $1";
				queryParameters.push_back((int) numericParameters["job_id"]);
				if(modulus > 1){
					query += "  and time % $2 = 0";
					queryParameters.push_back((int) numericParameters["modulus"]);
				}
				query += " order by time asc"; // Test data is sometimes ordered illogically
				break;
		}

		// Run query to obtain frames
		auto frames = Database::DBUtil::query(query, queryParameters);

		// A job should at least have one frame
		if(frames.size() == 0){
			// Nothing do to; header cannot be constructed and no rows to serialize.
			string error = "Webserver: Frames: No data found.";
			responseBody = error;
			cerr << error << endl;
			return HTTP::NOT_FOUND;
		}

		// Start preparing JSON object to return
		json outputObject;
		outputObject["frames"] = {};
		outputObject["parameters"] = {};

		// Write frames to the JSON object
		for(auto& row: frames){
			for(auto& [column, value]: row){
				outputObject["frames"][column].push_back(value);
			}
		}

		// When in job mode, fetch job parameters and write to the JSON object
		if(mode == Job){ // key, value, job_id
			auto parameterRows = Database::DBUtil::query("\
				select * from job_parameter \
				where job_id = $1 \
			", {(int) numericParameters["job_id"]});
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
				outputObject["parameters"][(string) row["key"]] = (string) row["value"];
			}
		}

		responseBody = outputObject;

		cout << "first frame time" << frames[0]["time"].toString() << "parm long min " << queryParameters[0].toString() << endl;

		return HTTP::OK;
	}
}
