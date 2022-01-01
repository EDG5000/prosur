/*
 * Prosur: Production Surveyor
 * Logs all activity in your additive production facility.
 */

#include "Main.hpp"

#include <thread>
#include <map>
#include <iostream>
#include <inttypes.h>
#include <ctime>

#include "Datasource/Camera/Camera.hpp"
#include "Database/Database.hpp"
#include "Datasource/RepRap/RepRap.hpp"
#include "Datasource/AuxTemp/AuxTemp.hpp"
#include "Webserver/Webserver.hpp"
#include "Util/Util.hpp"

using namespace std;
using namespace Prosur;

namespace Prosur{

int64_t frameTime = 0; // Updated at beginning of cycle. Used by dbclient. Must be unique across frames. Type matches that of time column in database.

constexpr auto cycleTime = 1000ms;

extern "C" int main() {
	Webserver::init();
	Database::init();

	while(true){
		this_thread::sleep_for(Prosur::cycleTime);
	}

	bool was_printing = false;
	//thread t{[=]{
			while(true){
				#ifdef TEST_MODE
					frameTime++;
				#else
					frameTime = time(NULL);
				#endif

				// Retrieve aux. temperatures
				Datasource::AuxTemp::update();
				for(int sensorIndex = 0; sensorIndex < Datasource::AuxTemp::temperatures.size(); sensorIndex++){
					Database::numericValues["temp_aux_" + to_string(sensorIndex)] = Datasource::AuxTemp::temperatures[sensorIndex];
				}

				Datasource::RepRap::update();

				// Insert data from values into database
				Database::update();


				/*
				if(!cclient::update()){
					cerr << "main: cclient experienced failure. skipping cycle." << endl;
					this_thread::sleep_for(cyleTime);
					continue;
				}

				cout << cclient::image.size() << endl;
				util::writeDataToFileDebug(cclient::image, "/home/joel/file.jpg");
				*/





				// Store properties of rrclient_om and tmclient_om in frames table
				#ifndef TEST_MODE
					// TODO
					this_thread::sleep_for(Prosur::cycleTime);
				#endif
				// TODO implement timing caluclation to ensure steady .1Hz operation
			}

	//}};

	//while(true){
	//	this_thread::sleep_for(1000ms);
	//}
	return 0;
}

}

