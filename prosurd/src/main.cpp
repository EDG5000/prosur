#include <iostream>

#include "inttypes.h"

#include <thread>
#include <map>

#include "rrfclient.hpp"
#include "tmclient.hpp"
#include "cclient.hpp"
#include "util.hpp"

using namespace std;

constexpr auto cyleTime = 1000ms;

int main() {
	if(!tmclient::init()){
		cerr << "main: tmclient init failed." << endl;
	}

	bool was_printing = false;
	//thread t{[=]{
			while(true){
				if(!tmclient::update()){
					cerr << "main: tmclient update failed, skipping cycle" << endl;
					this_thread::sleep_for(cyleTime);
					continue;
				}
				for(auto const& sensorData: tmclient::temperatures){
					cout << sensorData.first << ": " << tmclient::temperatures[sensorData.second] << endl;
				}


				/*
				if(!cclient::update()){
					cerr << "main: cclient experienced failure. skipping cycle." << endl;
					this_thread::sleep_for(cyleTime);
					continue;
				}

				cout << cclient::image.size() << endl;
				util::writeDataToFileDebug(cclient::image, "/home/joel/file.jpg");
				*/

				/*

				if(!rrfclient::update()){
					cerr << "main: rrfclient experienced failure. skipping cycle." << endl;
					this_thread::sleep_for(cyleTime);
					continue;
				}
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
				this_thread::sleep_for(cyleTime);
			}

	//}};

	//while(true){
	//	this_thread::sleep_for(1000ms);
	//}
	return 0;
}
