/*
 *  Webserver Resource: File. Returns either:
 *  - A Job's associated file, by supplying a Job ID.
 *  - A still belonging to a particular Frame, by supplying the still index (always 0 if only one camera is installed) and the timestamp
 *  See Main.cpp to determine which timetamps should have stills associated with them (hint: every sixth frame, due to the modulus operation used to determine whether to capture an image or not, as seen in Main.cpp).
 *  URL examples:
 *  /file?mode=still&still_id=0&time=123456890
 *  /file?mode=job&job_id=1234
 */

#include "Webserver/Resources/File.hpp"

#include <string>
#include <map>
#include <vector>

#include "Webserver/Webserver.hpp"
#include "Util/Util.hpp"
#include "Database/Database.hpp"
#include "Database/DBUtil.hpp"
#include "Log.hpp"

using namespace std;

namespace Prosur::Webserver::Resources::File{
	const string COLUMN_PREFIX = "still_"; // Column when accessing stills by number, e.g. still_0
	constexpr int STILL_COLUMN_COUNT = 1; // May be expanded once the Camera module can retrieve images from multiple cameras. Note: add missing columns to database.

	enum Mode{
		Still, // Retrieve a still for a given frame. Required parameters: time, still_id
		Job // Retrieve the file belonging to a given print job. Required parameters: job_id
	};

	map<string, Mode> modeValues = {
			{"still", Still},
			{"job", Job}
	};

	map<Mode, vector<string>> mandatoryParams = {
			{Still, {"min", "max", "still_id"}},
			{Job, {"job_id"}}
	};

	int run(string resource, HTTPResponseBody& responseBody, map<string,string> params){
		// Ensure mode param is present
		if(!params.contains("mode")){
			responseBody = "Webserver: File: mode param is missing, while it is mandatory.";
			log(responseBody);
			return HTTP::BAD_REQUEST;
		}

		// Ensure mode param is valid
		if(!modeValues.contains(params["mode"])){
			responseBody = "Webserver: File: mode param does not correspond to any of the available modes.";
			log(responseBody);
			return HTTP::BAD_REQUEST;
		}

		// Set mode param
		Mode mode = modeValues[params["mode"]];

		// Ensure mandatory params are present and numeric; store parsed integer params
		map<string, int> numericParams;
		for(string& key: mandatoryParams[mode]){
			if(!params.contains(key)){
				responseBody = "Webserver: File: missing mandatory param: " + key + " when in mode " + params["mode"];
				log(responseBody);
				return HTTP::BAD_REQUEST;
			}
			try{
				numericParams[key] = stoi(params[key]);
			}catch(const exception& e){
				responseBody = "Webserver: File: param " + key + " is not a valid integer, which is illegal.";
				log(responseBody);
				return HTTP::BAD_REQUEST;
			}
			if(numericParams[key] < 0){
				responseBody = "Webserver: File: param " + key + " is lower than zero, which is illegal.";
				log(responseBody);
				return HTTP::BAD_REQUEST;
			}
		}

		vector<map<string, Database::DBValue>> rows;
		string colName;

		// Construct relevant query and retrieve data
		if(mode == Still){
			// Ensure still_id is within legal range
			if(numericParams["still_id"] > (STILL_COLUMN_COUNT-1)){
				responseBody = "Webserver: File: param still_id is higher than " + to_string(STILL_COLUMN_COUNT-1) + ", which is illegal.";
				log(responseBody);
				return HTTP::BAD_REQUEST;
			}
			// Construct column name
			colName = COLUMN_PREFIX + to_string(numericParams["still_id"]);
			rows = Database::DBUtil::query("\
				select "+colName+" \
				from frame \
				where time > $1 and time < $2 and "+colName+" is not null \
				order by time desc \
				limit 1 \
				", {(int64_t) numericParams["min"], (int64_t) numericParams["max"]}
			);
		}else if(mode == Job){
			colName = "data";
			rows = Database::DBUtil::query("\
				select job_file.data \
				from job_file \
				join frame on frame.job_file_name = job_file.name \
				where job_id = $1 and frame.job_file_name is not null \
				limit 1 \
				", {numericParams["job_id"]}
			);
		}

		if(rows.size() == 0){
			return HTTP::NOT_FOUND;
		}

		if(rows.size() > 1){
			responseBody = "Webserver: File: Multiple rows were returned unexpectedly. Row count: " + to_string(rows.size());
			log(responseBody);
			return HTTP::INTERNAL_SERVER_ERROR;
		}

		if(!rows[0].contains(colName)){
			responseBody = "Webserver: File: Column: " + colName + " not found in response data. Available columns:";
			for(auto& [key, value]: rows[0]){
				responseBody += " " + key;
			}
			log(responseBody);
			return HTTP::INTERNAL_SERVER_ERROR;
		}

		if(mode == Job){
			// Return textual data, considered by HTTPResponseBody as text/plain
			responseBody = (string) rows[0][colName];
		}else if(mode == Still){
			// Return binary data, assumed by HTTPResponseBody to be of type image/jpeg
			responseBody = (vector<char>)rows[0][colName];
		}

		return HTTP::OK;
	}
}
