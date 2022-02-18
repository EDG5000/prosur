#include <Webserver/Resources/Jobs.hpp>

#include <string>
#include <map>

#include "Webserver/Webserver.hpp"
#include "Util/Util.hpp"
#include "Database/Database.hpp"
#include "Database/DBUtil.hpp"
#include "Log.hpp"

using namespace std;

namespace Prosur::Webserver::Resources::Job{
	int run(string resource, HTTPResponseBody& responseBody, map<string,string> parameters){

		const string KEY_JOB_ID = "job_id";

		if(!parameters.contains(KEY_JOB_ID)){
			responseBody = "Webserver: Job: job_id parameter missing.";
			log(responseBody);
			return HTTP::BAD_REQUEST;
		}

		int jobId;
		try{
			jobId = stoi(parameters[KEY_JOB_ID]);
		}catch(const exception& e){
			responseBody = "Webserver: Error: parameter " + KEY_JOB_ID + " is non-numeric. reason: " + string(e.what());
			log(responseBody);
			return HTTP::BAD_REQUEST;
		}

		// Start preparing JSON object to return
		json outputObject = {};

		// When in job mode, fetch job parameters and write to the JSON object
		auto parameterRows = Database::DBUtil::query("\
			select * from job_parameter \
			where job_id = $1 \
		", {jobId});

		// Get job parameter key and value from each row, put in JSON object
		for(auto& row: parameterRows){
			if(!row.contains("key")){
				log("Database::Resource::Frames: Missing column: key from output.");
				terminate();
			}
			if(!row.contains("value")){
				log("Database::Resource::Frames: Missing column: value from output.");
				terminate();
			}
			outputObject[(string) row["key"]] = (string) row["value"];
		}

		responseBody = outputObject;

		return HTTP::OK;
	}
}
