#include "Webserver/Resources/List.hpp"

#include <string>
#include <map>

#include "Webserver/Webserver.hpp"
#include "Util/Util.hpp"
#include "Database/Database.hpp"
#include "Database/DBUtil.hpp"

using namespace std;

namespace Prosur::Webserver::Resources::List{
	int run(HTTPResponseBody& responseBody, map<string,string> params){
		// Perform query extracting records each representing a job
		// We are only interested in job_id, plus 2 descriptive labels (time and filename)
		auto jobs = Database::DBUtil::query(
			"select time, file_name, job_id from frame"\
			" where job_id is not null"\
			" group by job_id, time"
			, {}
		);

		for(auto& job: jobs){
			int64_t time = job["time"];
			string filename = job["file_name"];
			int job_id = job["job_id"];
			responseBody += string("<a href=\"/job?id=" + to_string(job_id) + "\">" + Util::isodatetime(time) + "(" + filename + ").csv</a><br />\n");
		}

		return HTTP::OK;
	}
}
