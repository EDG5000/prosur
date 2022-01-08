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
#include <filesystem>

#include <time.h>
#include <arpa/inet.h>

#include <postgresql/libpq-fe.h>

#include "Datasource/RepRap/RepRap.hpp"
#include "Database/DBUtil.hpp"
#include <Database/DBValue.hpp>
#include "Database/Frame.hpp"
#include "Util/Util.hpp"

using namespace std;
using namespace filesystem;

namespace Prosur::Database{
	// Set to latest inserted job at startup, incremented at runtime prior to insertion of a new job's first frame.
	// Is written to each frame as long as RepRapClient::is_printing.
	int lastJobId = -1;

	map<string, string> frameColumnTypes; // Currently only read by Webserver::Resource::Frames

	void init(){
		// Load and execute the database creation script to ensure the database is created and present
		std::ifstream t(current_path().string() + "/database.sql");
		std::stringstream buffer;
		buffer << t.rdbuf();
		string databaseCreationScript = buffer.str();
		if(databaseCreationScript.size() == 0){
			cerr << "Database: Error: Unable to load database.sql from current path. Make sure ${CWD}/database.sql exists." << endl;
			terminate();
		}
		DBUtil::query(databaseCreationScript.c_str());

		// Obtain the latest jobId currently in the database
		auto result = DBUtil::query("\
			select job_id from frame \
			where job_id is not null \
			order by job_id desc \
			limit 1 \
		");

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
		
		// Obtain list of column type (this is only used when Webserver is serving the Frames resource)
		result = DBUtil::query("select column_name::text, data_type::text from information_schema.columns where table_name = $1", {"frame"});
		for(auto& row: result){
			frameColumnTypes[row["column_name"]] = (string) row["data_type"];
		}
	}

	static int64_t fileExists(string filename){
		auto result = DBUtil::query("select name, modified from job_file where name = $1", {filename});
		if(result.size() == 0){
			return -1;
		}
		return result[0]["modified"];
	}

	void insertFrame(Frame& frame){
		DBUtil::query("begin"); // Begin transaction involving job_file insert and frame insert

		// Check if this is the first frame of a new job
		bool newJob = frame.isPrinting && !frame.wasPrinting;

		// Create new jobId
		if(newJob){
			lastJobId++;
		}

		// Set jobId
		if(frame.isPrinting){
			frame.jobId = lastJobId;
		}

		// Insert job file if needed; insert job parameters
		if(newJob){
			// Get filename and date modified of current job file
			if(frame.jobFilename == ""){
				cerr << "DatabaseClient: update: Error: get_current_job_filename returned empty string, cannot insert job." << endl;
				terminate();
			}

			int64_t jobFileModified = frame.jobFileModified;

			// Determine if a new new file needs to be inserted, adjust filename as needed
			int64_t existingFileModified = fileExists(frame.jobFilename);
			int iterations = 0;
			while(existingFileModified != -1 && existingFileModified != frame.jobFileModified && iterations < 10){
				frame.jobFilename += " (1)"; // Keep renaming until unique, if timestamps differ
				existingFileModified = fileExists(frame.jobFilename);
				iterations++;
			}
			if(iterations == 10){ // No more then 10 iterations are reasonable
				cerr << "DatabaseClient: update: Infinite loop when trying to find unique filename, aborting. Filename: " << frame.jobFilename << endl;
				terminate();
			}

			// Insert new file now if needed
			if(existingFileModified == -1){
				DBUtil::query("insert into job_file (name, modified, data) values ($1, $2, $3)", {
						frame.jobFilename,
						frame.jobFileModified,
						frame.jobFile
				});
			}

			// Store the job parameters for this job in the job_parameter table
			for(const auto& [key, value]: frame.jobParameters){
				DBUtil::query("\
					insert into job_parameter (job_id, key, value) \
					values($1, $2, $3) \
				", {frame.jobId, key, value});
			}
		}

		// Export Frame into a map of DBValue instances
		map<string, DBValue> row;
		frame.exportMap(row);

		// Generate string of numeric placeholder
		string paramPlaceholders = "$1";
		for(int i = 1; i < row.size(); i++){
			// Add numbered placeholder
			paramPlaceholders += ", $" + to_string(i+1);
		}

		// Create comma-separated list of columns
		vector<string> columns;
		vector<DBValue> values;
		for(auto& [key, value]: row){
			// Add column name
			columns.push_back(key);
			values.push_back(value);
		}
		string columnString = Util::join(columns, ", ");

		// Run query
		DBUtil::query(
			"insert into frame " \
			"("+  columnString + ") " \
			"values (" + paramPlaceholders + ")",
			values
		);
		DBUtil::query("end"); // Commit transaction
	}

}
