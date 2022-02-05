#include <Webserver/Resources/Jobs.hpp>

#include <string>
#include <map>

#include "Webserver/Webserver.hpp"
#include "Util/Util.hpp"
#include "Database/Database.hpp"
#include "Database/DBUtil.hpp"

using namespace std;

namespace Prosur::Webserver::Resources::Jobs{
	int run(HTTPResponseBody& responseBody, map<string,string> params){
		// Perform query extracting records each representing a job
		auto jobs = Database::DBUtil::query("\
			select distinct on(job_id) time, job_id, job_file_name \
			from frame \
			where job_id is not null \
			order by job_id, time asc \
		");

		// Create JSON array to store return data
		json returnObject;
		for(auto& row: jobs){
			json job;
			job["time"] = row["time"];
			//cout << job["time"] << endl;
			job["job_file_name"] = row["job_file_name"];
			job["job_id"] = row["job_id"];
			returnObject.push_back(job);
		}
		responseBody = returnObject;
		return HTTP::OK;
	}
}
