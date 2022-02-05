#include <Webserver/Resources/Jobs.hpp>

#include <string>
#include <map>

#include "Webserver/Webserver.hpp"
#include "Util/Util.hpp"
#include "Database/Database.hpp"
#include "Database/DBUtil.hpp"

using namespace std;

namespace Prosur::Webserver::Resources::Job{
	int run(HTTPResponseBody& responseBody, map<string,string> parameters){

		if(!parameters["job_id"].exists()){
			?? TODO
		}

		// Start preparing JSON object to return
		json outputObject = {};

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
				outputObject[(string) row["key"]] = (string) row["value"];
			}
		}

		responseBody = outputObject;

		//cout << "first frame time" << frames[0]["time"].toString() << "parm long min " << queryParameters[0].toString() << endl;

		return HTTP::OK;
}
