#include "Main.hpp"

#include "AuxTempClient/AuxTempClient.hpp"
#include "CameraClient/CameraClient.hpp"
#include "RepRapClient/RepRapClient.hpp"
#include "DatabaseClient/DatabaseClient.hpp"

#include <Util/Util.hpp>
#include <iostream>

#include "inttypes.h"

#include <thread>
#include <map>
#include <iostream>


using namespace std;
using namespace Prosur;

namespace Prosur{


map<string, int32_t> values;
vector<char> imageData; // Data from the last-captured image.
int64_t time; // Updated at beginning of cycle. Used by dbclient. Must be unique across frames. Type matches that of time column in database.

constexpr auto cycleTime = 1000ms;

}


int main() {
	/*if(!tmclient::init()){
		cerr << "main: tmclient init failed." << endl;
		terminate();
	}*/

	if(!DatabaseClient::init()){
		cerr << "main: dbclient init failed." << endl;
		terminate();
	}

	bool was_printing = false;
	//thread t{[=]{
			while(true){
				// Retrieve aux. temperatures
				/*if(!tmclient::update()){
					cerr << "main: tmclient update failed, skipping cycle" << endl;
					this_thread::sleep_for(cycleTime);
					continue;
				}*/
				// Store aux. temperatures
				for(int sensorIndex = 0; sensorIndex < AuxTemp::temperatures.size(); sensorIndex++){
					values["temp_aux_" + to_string(sensorIndex)] = AuxTemp::temperatures[sensorIndex];
				}

				// Insert data from values into database
				/*if(!dbclient::update()){
					cerr << "main: dbclient update failed, skipping cycle" << endl;
					this_thread::sleep_for(cycleTime);
					continue;
				}*/


				/*
				if(!cclient::update()){
					cerr << "main: cclient experienced failure. skipping cycle." << endl;
					this_thread::sleep_for(cyleTime);
					continue;
				}

				cout << cclient::image.size() << endl;
				util::writeDataToFileDebug(cclient::image, "/home/joel/file.jpg");
				*/

				if(!RepRapClient::update()){
					cerr << "main: rrfclient experienced failure. skipping cycle." << endl;
					this_thread::sleep_for(cycleTime);
					continue;
				}
				cout << RepRapClient::get_current_job_filename() << endl;
				terminate();
				/*
				if(rrfclient::get_is_printing() && !was_printing){
					// Transition to printing
					// Insert job, get ID back, store ID globally
				}else if(!rrfclient::get_is_printing() && was_printing){
					// Transition to not printing
					// Set JOB id to NULL
				}else if(rrfclient::get_is_printing()){
					// Printing, no transition
				}
				*/

				// Store properties of rrclient_om and tmclient_om in frames table
				this_thread::sleep_for(Prosur::cycleTime);
				// TODO implement timing caluclation to ensure steady .1Hz operation
			}

	//}};

	//while(true){
	//	this_thread::sleep_for(1000ms);
	//}
	return 0;
}
