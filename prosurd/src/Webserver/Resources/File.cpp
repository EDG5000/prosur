#include "Webserver/Resources/List.hpp"

#include <string>
#include <map>
#include <vector>

#include "Webserver/Webserver.hpp"
#include "Util/Util.hpp"
#include "Database/Database.hpp"
#include "Database/DBUtil.hpp"

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
			{Still, {"time", "still_id"}},
			{Job, {"job"}}
	};

	int run(HTTPResponseBody& responseBody, map<string,string> params){
		// Ensure mode param is present
		if(!params.contains("mode")){
			responseBody = "Webserver: File: mode param is missing, while it is mandatory.";
			cerr << responseBody.stringData << endl;
			return HTTP_BAD_REQUEST;
		}

		// Ensure mode param is valid
		if(!modeValues.contains(params["mode"])){
			responseBody = "Webserver: File: mode param does not correspond to any of the available modes.";
			cerr << responseBody.stringData << endl;
			return HTTP_BAD_REQUEST;
		}

		// Set mode param
		Mode mode = modeValues[params["mode"]];

		// Ensure mandatory params are present and numeric; store parsed integer params
		map<string, int> numericParams;
		for(string& key: mandatoryParams[mode]){
			if(!params.contains(key)){
				responseBody = "Webserver: File: missing mandatory param: " + key + " when in mode " + params["mode"];
				cerr << responseBody.stringData << endl;
				return HTTP_BAD_REQUEST;
			}
			try{
				numericParams[key] = stoi(params[key]);
			}catch(const exception& e){
				responseBody = "Webserver: File: param " + key + " is not a valid integer, which is illegal.";
				cerr << responseBody.stringData << endl;
				return HTTP_BAD_REQUEST;
			}
			if(numericParams[key] < 0){
				responseBody = "Webserver: File: param " + key + " is lower than zero, which is illegal.";
				cerr << responseBody.stringData << endl;
				return HTTP_BAD_REQUEST;
			}
		}

		vector<map<string, Database::DBParam>> rows;
		string colName;

		// Construct relevant query and retrieve data
		if(mode == Still){
			// Ensure still_id is within legal range
			if(numericParams["still_id"] > (STILL_COLUMN_COUNT-1)){
				responseBody = "Webserver: File: param still_id is higher than " + to_string(STILL_COLUMN_COUNT-1) + ", which is illegal.";
				cerr << responseBody.stringData << endl;
				return HTTP_BAD_REQUEST;
			}
			// Construct column name
			colName = COLUMN_PREFIX + to_string(numericParams["still_id"]);
			rows = Database::DBUtil::query(
				"select $1" \
				" from frame" \
				" where time = $2",
				{numericParams["job_id"]}
			);
		}else if(mode == Job){
			colName = "file.data";
			rows = Database::DBUtil::query(
				"select file.data" \
				" from file" \
				" inner join frame on frame.file_name = file.name" \
				" where job_id = $1 and frame.file_name is not null",
				{numericParams["job_id"]}
			);
		}

		if(rows.size() == 0){
			if(numericParams["still_id"] > (STILL_COLUMN_COUNT-1)){
				responseBody = "Webserver: File: No such file.";
				cerr << responseBody.stringData << endl;
				return HTTP_NOT_FOUND;
			}
		}

		if(rows.size() > 1){
			responseBody = "Webserver: File: Multiple rows were returned unexpectedly.";
			cerr << responseBody.stringData << endl;
			return HTTP_INTERNAL_SERVER_ERROR;
		}

		if(!rows[0].contains(colName)){
			responseBody = "Webserver: File: Column: " + colName + " not found in response data. Available columns:";
			for(auto& [key, value]: rows[0]){
				responseBody += " " + key;
			}
			cerr << responseBody << endl;
			return HTTP_INTERNAL_SERVER_ERROR;
		}

		responseBody = (vector<char>) rows[0][colName];
		return HTTP_OK;
	}
}
