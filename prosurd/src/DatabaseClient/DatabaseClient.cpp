#include "DatabaseClient/DatabaseClient.hpp"
#include "DatabaseClient/DatabaseClient.hpp"

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
#include <RepRapClient/RepRapClient.hpp>
#include "DatabaseClient/DBUtil.hpp"

using namespace std;

namespace Prosur::DatabaseClient{

	// TODO consider moving


	// Set to latest inserted job at startup, incremented at runtime prior to insertion of a new job's first frame.
	// Is written to each frame as long as RepRapClient::is_printing.
	int lastJobId = -1;

	bool init(){
		// As no host is supplied, libpq will connect using UNIX-domain socket for optimal performance.
		// Ensure the following is present in the table in /etc/postgres/12/main/pg_hba.conf:
		// # TYPE  DATABASE        USER            ADDRESS                 METHOD
		// local   all             all                                     trust
		// Warning: Use "trust" authentication only when there are no other untrusted Unix users on the system.
		DBUtil::connect("dbname=postgres user=postgres");

		// Obtain the latest jobId currently in the database
		PGresult* result = DBUtil::query(
			"select job_id from frame "\
			"order by job_id desc "\
			"limit 1"
		);

		if(PQresultStatus(result) != PGRES_TUPLES_OK){
			cerr << "dbclient: Unable to obtain latest job_id value. Error: " << DBUtil::getError() << endl;
			return false;
		}

		// Get col number
		int colNum = PQfnumber(result, "job_id");
		if(colNum == -1){
			cerr << "dbclient: Unable to obtain colNum for column job_id" << endl;
			return false;
		}

		// Get row count
		int rowCount = PQntuples(result);

		// Set lastJobId
		if(rowCount == 0){
			// No existing jobs present, start ID at 0
			lastJobId = 0;
		}else if(rowCount != 1){
			cerr << "dbclient: Unable to obtain latest job_id value. Row count was not 1, but " << rowCount << endl;
			return false;
		}else if(rowCount == 1){
			// Dereference, cast, and reverse byte order to little endian.
			lastJobId = ntohl(*((uint32_t*)PQgetvalue(result, 0, colNum)));
		}

		PQclear(result);

		return true;
	}

	static int64_t file_exists(string filename){
		PGresult* result = DBUtil::query("select name, modified from file where name = $1", {filename});
		if(result == NULL){
			cerr << "dbclient: file_exists: Unable to perform query. Aborting" << endl;
			terminate();
		}
		int64_t ret_val;
		if(PQntuples(result) == 1){
			ret_val = *((int64_t*)PQgetvalue(result, 0, 1));
		}else{
			ret_val = -1;
		}
		PQclear(result);
		return ret_val;
	}

	bool update(){
		// 1. Create file entry if this is the start of a new job
		bool newJob = RepRapClient::is_printing() && !RepRapClient::was_printing();
		if(newJob){
			// 1.1 Create new jobId for insertion into database
			lastJobId++;

			// 1.2 Get filename and date modified of current job file
			string current_job_filename = RepRapClient::get_current_job_filename();
			int64_t current_job_file_modified = RepRapClient::get_current_job_modified();

			// 1.3. Determine if new file needs to be inserted, adjust filename as needed
			int64_t existing_file_modified = file_exists(current_job_filename);
			int iterations = 0;
			while(existing_file_modified != -1 && existing_file_modified != current_job_file_modified && iterations < 10){
				current_job_filename += " (1)"; // Keep renaming until unique, if timestamps differ
				existing_file_modified = file_exists(current_job_filename);
				iterations++;
			}
			if(iterations == 10){ // No more then 10 iterations are reasonable
				cerr << "dbclient: update: Infinite loop when trying to find unique filename, aborting. Filename: " << current_job_filename << endl;
				terminate();
			}

			// 1.4 Insert new file now if needed
			if(existing_file_modified == -1){
				PGresult* result = DBUtil::query("insert into file (name, modified, data) values ($1, $2, $3)", {
						current_job_filename,
						current_job_file_modified,
						RepRapClient::lastJobFile
				});
				if(result == NULL){
					cerr << "dbclient: update: Error while trying to insert file " << current_job_filename << "(size: " << RepRapClient::lastJobFile.size() << ")" << endl;
					terminate();
				}
			}
		}

		// 2. Insert frame
		// 2.1. Setup initial parameters
		int job_id = lastJobId;
		if(!RepRapClient::is_printing()){
			job_id = INT32_MAX; // Sets job ID to NULL when not printing
		}
		string file_name;
		if(newJob){
			// Store job filename if this is a new job
			file_name = RepRapClient::get_current_job_filename();
		}
		vector<DBUtil::Param> params = {time, job_id, file_name};

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
		PGresult* result = DBUtil::query(query, params);
		if(result == NULL){
			cerr << "dbclient: update: Failed to perform query: " << query << " with param count " << params.size() << endl;
			terminate();
		}

		PQclear(result);
		return true;
	}

}
