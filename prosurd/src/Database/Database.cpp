#include <Database/Database.hpp>

#include <map>
#include <string>
#include <vector>
#include <iostream>
#include <fstream>
#include <streambuf>
#include <sstream>
#include <ctime>
#include <climits>
#include <arpa/inet.h>

#include <postgresql/libpq-fe.h>

#include <Main.hpp>
#include <Datasource/RepRap/RepRap.hpp>
#include <Database/DBUtil.hpp>
#include <time.h>

using namespace std;

namespace Prosur::Database{
	// Set to latest inserted job at startup, incremented at runtime prior to insertion of a new job's first frame.
	// Is written to each frame as long as RepRapClient::is_printing.
	int lastJobId = -1;

	void init(){
		// As no host is supplied, libpq will connect using UNIX-domain socket for optimal performance.
		// Warning: Use "trust" authentication only when there are no other untrusted Unix users on the system.
		// Ensure the following is present in the table in /etc/postgres/12/main/pg_hba.conf:
		// # TYPE  DATABASE        USER            ADDRESS                 METHOD
		// local   all             all                                     trust
		DBUtil::connect("dbname=postgres user=postgres");

		// Obtain the latest jobId currently in the database
		auto result = DBUtil::query(
			"select job_id from frame "\
			"order by job_id desc "\
			"limit 1"
		);

		// Set lastJobId
		if(result.size() == 0){
			// No existing jobs present, start ID at 0
			lastJobId = 0;
		}else if(result.size() != 1){
			cerr << "DatabaseClient: Unable to obtain latest job_id value. Row count was not 1, but " << result.size()  << endl;
			terminate();
		}else if(result.size() == 1){
			lastJobId = result[0]["job_id"];
		}
	}

	static int64_t file_exists(string filename){
		auto result = DBUtil::query("select name, modified from file where name = $1", {filename});
		if(result.size() == 0){
			return -1;
		}
		return result[0]["modified"];
	}

	void update(){
		// 1. Create file entry if this is the start of a new job
		bool newJob = Datasource::RepRap::is_printing() && !Datasource::RepRap::was_printing();
		string current_job_filename;
		if(newJob){
			// 1.1 Create new jobId for insertion into database
			lastJobId++;

			// 1.2 Get filename and date modified of current job file
			string current_job_filename = Datasource::RepRap::get_current_job_filename();
			if(current_job_filename == ""){
				cerr << "DatabaseClient: update: Error: get_current_job_filename returned empty string, cannot insert job." << endl;
				terminate();
			}

			int64_t current_job_file_modified = Datasource::RepRap::get_current_job_modified();

			// 1.3. Determine if new file needs to be inserted, adjust filename as needed
			int64_t existing_file_modified = file_exists(current_job_filename);
			int iterations = 0;
			while(existing_file_modified != -1 && existing_file_modified != current_job_file_modified && iterations < 10){
				current_job_filename += " (1)"; // Keep renaming until unique, if timestamps differ
				existing_file_modified = file_exists(current_job_filename);
				iterations++;
			}
			if(iterations == 10){ // No more then 10 iterations are reasonable
				cerr << "DatabaseClient: update: Infinite loop when trying to find unique filename, aborting. Filename: " << current_job_filename << endl;
				terminate();
			}

			// 1.4 Insert new file now if needed
			if(existing_file_modified == -1){
				DBUtil::query("insert into file (name, modified, data) values ($1, $2, $3)", {
						current_job_filename,
						current_job_file_modified,
						Datasource::RepRap::lastJobFile
				});
			}
		}

		// 2. Insert frame
		// 2.1. Setup initial parameters
		int job_id = lastJobId;
		if(!Datasource::RepRap::is_printing()){
			job_id = INT32_MAX; // Sets job ID to NULL when not printing
		}

		vector<DBUtil::Param> params = {frameTime, job_id, current_job_filename}; // Filename is filled when it is the first frame of the job. DBUtil will store NULLs in DB.

		// 2.2 Use prosurd::values to generate query and append to parameter vector
		const int FIXED_PARAM_COUNT = 3; // Match with below query
		const int PARAM_COUNT = FIXED_PARAM_COUNT + Prosur::values.size();
		string query = "insert into frame (time, job_id, file_name, ";
		int i = 0;
		for(auto& [key, value]: Prosur::values){
			params.push_back(value);
			query += key;
			if(i != Prosur::values.size()-1){
				query += ", ";
			}
			i++;
		}
		query += ") values (";
		for(int i = 0; i < PARAM_COUNT; i++){
			query += "$" + to_string(i+1);
			if(i != PARAM_COUNT-1){
				query += ", ";
			}
		}
		query += ")";

		// 2.3 Perform insertion query
		DBUtil::query(query, params);
	}

}
