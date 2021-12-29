/*
 * WARNING: Only run on a network where all machines are trusted and behind a NAT.
 * This is free software; see the source for copying conditions.  There is NO
 * warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 */

#include "Webserver/Webserver.hpp"

#include <iostream>
#include <sys/types.h>
#include <sys/select.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <microhttpd.h>
#include <string>

#include "Database/DBUtil.hpp"
#include "Util/Util.hpp"

using namespace std;

namespace Prosur::Webserver{

	constexpr int PORT = 8080;
	constexpr int BUF_SIZE = 1024;
	constexpr int MAX_URL_LEN = 255;
	string ERROR_PAGE = "<html><head><title>File not found</title></head><body><h1>HTTP 404: File not found</h1></body></html>";
	enum Mode{
		List, // List jobs
		Job, // Download data for job
		Range // Download all data within time range, also when not printing
	};

	struct MHD_Daemon* daemon;

	static int respondWithError(MHD_Connection* connection, int httpCode){
		struct MHD_Response* response = MHD_create_response_from_buffer(ERROR_PAGE.size(), (void*) ERROR_PAGE.c_str(), MHD_RESPMEM_PERSISTENT);
		return MHD_queue_response (connection, httpCode, response);
	}

	static int accessHandler (void* cls, struct MHD_Connection* connection, const char* pUrl, const char* method, const char* version, const char* upload_data, size_t* upload_data_size, void** ptr){
		string url = string(pUrl); // e.g. /list

		// 1. Obtain request document and parameters. Either may be empty.
		// 1.1. Declare variables
		string requestDocument;
		map<string,string> requestParameters; // Store request params, if present

		// 1.2. Attempt to split the URI into document name and query string
		vector<string> urlSplit = Util::strSplit(url, "?");

		// 1.3. Extract document name (may be empty) from URL
		requestDocument = urlSplit[0];
		Util::replaceAll(requestDocument, "/", ""); // Remove preceding slash from URL

		// 1.4 Parse query string, if present
		if(urlSplit.size() > 1){
			// Extract query string into requestParameters map
			string queryString = urlSplit[1];
			vector<string> pairs = Util::strSplit(queryString, "&");
			for(const string& pair: pairs){
				vector<string> pairElements = Util::strSplit(pair, "=");
				if(pairElements.size() != 2){
					cerr << "Webserver: Error: Malformed URI. Pair element count expected to be 2. Source pair: " << pair << "Total URL: " << url << endl;
					return respondWithError(connection, MHD_HTTP_BAD_REQUEST);
				}
				string key = pairElements[0];
				string value = pairElements[1];
				requestParameters[key] = value;
			}
		}

		// 2. Select mode
		Mode mode;
		if(requestDocument == "job"){
			mode = Job;
		}else if(requestDocument == "range"){
			mode = Range;
		}else{
			// No document provided defaults to listing of jobs
			// This is behaviour clients may depend on
			mode = List;
		}

		if(mode == List){
			// Perform query extracting records each representing a job
			// We are only interested in job_id, plus 2 descriptive labels (time and filename)
			auto jobs = Database::DBUtil::query(
				"select time, file_name, job_id from frame"\
				" where job_id is not null"\
				" group by job_id, time"\
				" order by job_id desc"\
				, {}
			);

			string responseBody;
			for(auto& job: jobs){
				int64_t time = job["time"];
				string filename = job["filename"];
				int job_id = job["job_id"];
				responseBody += "<a href=\"/job?id=" + to_string(job_id) + "\">" + Util::isodatetime(time) + "(" + filename + ").csv</a><br />\n";
			}
			struct MHD_Response* response = MHD_create_response_from_buffer(responseBody.size(), (void*) responseBody.c_str(), MHD_RESPMEM_MUST_COPY);
			int ret = MHD_queue_response (connection, MHD_HTTP_OK, response);
			MHD_destroy_response (response);
			return ret;
		}else if(mode == Job){
			string responseBody = "<h1>HTTP -1 Not Implemented</h1>";
			struct MHD_Response* response = MHD_create_response_from_buffer(responseBody.size(), (void*) responseBody.c_str(), MHD_RESPMEM_MUST_COPY);
			int ret = MHD_queue_response (connection, MHD_HTTP_NETWORK_AUTHENTICATION_REQUIRED, response);
			MHD_destroy_response (response);
		}

	}

	void init(){
		daemon = MHD_start_daemon(
			MHD_USE_THREAD_PER_CONNECTION | MHD_USE_INTERNAL_POLLING_THREAD | MHD_USE_DEBUG, // flags
			PORT,
			NULL, // Accept Policy Callback
			NULL, // Accept Policy Callback Argument
			&accessHandler,
			NULL, // Access Handler Argument
			MHD_OPTION_CONNECTION_TIMEOUT, 256,
			MHD_OPTION_END
		);
	}

	// Assume MHD is cleaned implicitly up when process exits
	/*void deinit(){
		MHD_stop_daemon (TLS_daemon);
	}*/
}


