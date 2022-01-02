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

#include <time.h>
#include <arpa/inet.h>

#include <postgresql/libpq-fe.h>

#include "Datasource/RepRap/RepRap.hpp"
#include "Database/DBUtil.hpp"
#include <Database/DBValue.hpp>
#include "Util/Util.hpp"

using namespace std;

namespace Prosur::Database{
	// Set to latest inserted job at startup, incremented at runtime prior to insertion of a new job's first frame.
	// Is written to each frame as long as RepRapClient::is_printing.
	int jobId = -1;

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
			jobId = 0;
		}else if(result.size() != 1){
			cerr << "DatabaseClient: Unable to obtain latest job_id value. Row count was not 1, but " << result.size()  << endl;
			terminate();
		}else if(result.size() == 1){
			jobId = result[0]["job_id"];
		}
	}

	static int64_t fileExists(string filename){
		auto result = DBUtil::query("select name, modified from file where name = $1", {filename});
		if(result.size() == 0){
			return -1;
		}
		return result[0]["modified"];
	}

	void insertFrame(Frame& frame){
		// Create file entry if this is the start of a new job
		bool newJob = frame.isPrinting && !frame.wasPrinting;
		if(newJob){
			// Create new jobId for insertion into database
			jobId++;

			// Get filename and date modified of current job file
			if(frame.jobFilename == ""){
				cerr << "DatabaseClient: update: Error: get_current_job_filename returned empty string, cannot insert job." << endl;
				terminate();
			}

			int64_t jobFileModified = frame.jobFileModified;

			// Determine if new file needs to be inserted, adjust filename as needed
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
				DBUtil::query("insert into file (name, modified, data) values ($1, $2, $3)", {
						frame.jobFilename,
						frame.jobFileModified,
						frame.jobFile
				});
			}
		}

/*
    "time" bigint NOT NULL,
    file_name text,
    job_id integer,
    temp_aux_7 real,
    temp_aux_6 real,
    temp_aux_5 real,
    temp_aux_4 real,
    temp_aux_3 real,
    temp_aux_2 real,
    temp_aux_1 real,
    temp_aux_0 real,
    temp_extruder_0 real,
    temp_bed_0 real,
    temp_chamber_0 real,
    pos_motor_0 real,
    pos_motor_1 real,
    pos_motor_2 real,
    pos_motor_3 real,
    print_progress_percentage real,
    print_layers_printed integer,
    print_layers_remaining integer,
    temp_cpu_0 real,
    speed_requested_mms real,
    speed_current_mms real,
    voltage integer,
    probe_z integer,
    probe_x integer,
    filament_used real,
    still_0 bytea,
    vin_0 real
*/

		// Create map of DBValues for insertion into frame table
		map<string, DBValue> row = {
			{"time", frame.time},
			{"job_id", frame.isPrinting ? jobId : INT32_MAX},
			{"file_name", frame.jobFilename}
		};

		// Add still images to map
		for(int i = 0; i < frame.still.size(); i++){
			row["still_" + to_string(i)] = frame.still[i];
		}

		// Add aux temperatures to map
		for(int i = 0; i < frame.auxTemp.size(); i++){
			row["temp_aux_" + to_string(i)] = frame.auxTemp[i];
		}

		// Add heater temperatures to map
		for(int i = 0; i < frame.heaterTemp.size(); i++){
			row["temp_heater_" + to_string(i)] = frame.heaterTemp[i];
		}

		// Voltage and temperatures per board; add to map
		for(int i = 0; i < frame.cpuTemp.size(); i++){
			row["temp_cpu_" + to_string(i)] = frame.cpuTemp[i];
			row["vin_" + to_string(i)] = frame.cpuTemp[i];
		}

		// Motor positions
		for(int i = 0; i < frame.motorPos.size(); i++){
			row["pos_motor_" + to_string(i)] = frame.motorPos[i];
		}

		// Endstop positions
		for(int i = 0; i < frame.endstop.size(); i++){
			row["endstop_" + to_string(i)] = frame.endstop[i];
		}

		// Probe positions
		for(int i = 0; i < frame.probe.size(); i++){
			row["probe_" + to_string(i)] = frame.probe[i];
		}

		// Coincidentally, the following lines ended up being sorted by length
		row["speed_current_mms"] = frame.speedCurrentMms;
		row["speed_requested_mms"] = frame.speedRequestedMms;
		row["print_layers_printed"] = frame.printLayersPrinted;
		row["print_layers_remaining"] = frame.printLayersRemaining;
		row["print_progress_percentage"] = frame.printProgressPercentage;

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
			"insert into frame" \
			"("+  columnString + ")" \
			"values (" + paramPlaceholders + ")",
			values
		);
	}

}
