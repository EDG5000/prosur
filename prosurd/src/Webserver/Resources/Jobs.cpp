#include <Webserver/Resources/Jobs.hpp>

#include <string>
#include <map>

#include "Webserver/Webserver.hpp"
#include "Util/Util.hpp"
#include "Database/Database.hpp"
#include "Database/DBUtil.hpp"
#include "Log.hpp"

using namespace std;

namespace Prosur::Webserver::Resources::Jobs{
	int run(string resource, HTTPResponseBody& responseBody, map<string,string> params){
		// Perform query extracting records each representing a job
		auto jobs = Database::DBUtil::query("\
			select distinct on(job_id) time, job_id, job_file_name \
			from frame \
			where job_id is not null \
			order by job_id, time asc \
		");

		// Create JSON array to store return data
		json returnObject = json::array();
		for(auto& row: jobs){
			json job;
			job["time"] = row["time"];
			//cerr + job["time"]);
			job["job_file_name"] = row["job_file_name"];
			job["job_id"] = row["job_id"];
			returnObject.push_back(job);
		}
		responseBody = returnObject;
		return HTTP::OK;
	}
}
