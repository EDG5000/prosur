/*
 * Prosur: Production Surveyor
 *
 * Logging all activity
 * in your additive production facility.
 *
 */

#include "Main.hpp"

#include <inttypes.h>
#include <unistd.h>
#include <fcntl.h>

#include <thread>
#include <map>
#include <iostream>
#include <ctime>

#include "Datasource/Camera/Camera.hpp"
#include "Datasource/RepRap/RepRap.hpp"
#include "Datasource/AuxTemp/AuxTemp.hpp"
#include "Database/Database.hpp"
#include "Webserver/Webserver.hpp"
#include "Util/Util.hpp"
#include "Database/Frame.hpp"
#include "Main.hpp"

using namespace std;
using namespace Prosur;

namespace Prosur{
	Database::Frame frame;

	void log(string line){
		cerr << (Util::isodatetime() + " " + line) << endl;
	}

	extern "C" int main() {
		log("a");
		// Redirect program output to log file
		//int fd = open("/var/log/prosurd.log", O_WRONLY, 0666);
		//dup2(fd, STDOUT_FILENO);
		//dup2(fd, STDERR_FILENO);

		std::set_terminate([](){
			// Print unhandled exceptions to log before exiting
			exception_ptr e = current_exception();
			if(e){
				try{
					rethrow_exception(e);
				}catch (const exception& e){
					cerr << e.what() << endl;
				}catch(...){
					log("Unknown exception.");
				}
			}
			cerr << Util::printStacktrace() << endl;
			abort();
		});

		Database::init();
		Webserver::init();

		while(true){
			//terminate();
			//stoi("a");
			//log("Frame");
			int64_t startTime = Util::timeUs();

			#ifndef TEST_FLAG_WEBMON_ONLY
				// Store isPrinting from previous frame; clear Frame and populate frame time
				bool wasPrinting = frame.isPrinting;
				frame = {};
				frame.time = startTime / 1000 / 1000;
				frame.wasPrinting = wasPrinting;

				// Data sources each fill Frame members
				Datasource::AuxTemp::fillFrame(frame);
				Datasource::RepRap::fillFrame(frame);

				// Collect stills only every 6th frame. At .1Hz, one still a minute.
				// TODO Use H.265 video to reduce data usage for still collection. How to implement this elegantly? Could chunks of data be written into each frame record in a bytea field? How would the performance be when having to stitch together 24hrs worth of frames? Can it be streamed over HTTP with seeking capability? Or is streaming to disk the only reasonable option? libavcodec could be used.
				if(frame.time % STILL_CAPTURE_INTERVAL == 0){
					// Record each 6th frame to reduce disk usage
					Datasource::Camera::fillFrame(frame);
				}

				// Insert frame into database
				Database::insertFrame(frame);
			#endif

			// Unless we are in TEST_MODE_MOCK_INPUT, sleep based on time taken during this cycle
			#ifndef TEST_MODE_MOCK_INPUT
				// Substract time taken during cycle with target interval
				int64_t timeTaken = Util::timeUs() - startTime;
				int64_t sleepTime = FRAME_COLLECTION_INTERVAL - timeTaken;
				//log("Time taken: " + timeTaken + " Sleep time: " + sleepTime);
				if(sleepTime < 0){
					log("warning: taking " + to_string(sleepTime * -1) + "us too long to keep up with desired " + to_string(FRAME_COLLECTION_INTERVAL) + "us interval. Operating at reduced frame collection rate.");
					sleepTime = 0;
				}
				usleep(sleepTime);
			#endif
		}
	}
}

