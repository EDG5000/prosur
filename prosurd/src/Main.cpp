/*
 * Prosur: Production Surveyor
 *
 * Logging all activity
 * in your additive production facility.
 *
 */

#include "Log.hpp"

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
#include "Log.hpp"
#include "Const.hpp"

using namespace std;
using namespace Prosur;

namespace Prosur{
	Database::Frame frame;

	extern "C" int main() {

		// Print unhandled exceptions to log before exiting
		set_terminate([](){
			exception_ptr e = current_exception();
			if(e){
				try{
					rethrow_exception(e);
				}catch (const exception& e){
					log("Uncaught exception: " + string(e.what()));
				}catch(...){
					log("Uncaught exception, aborting.");
				}
			}
			log("\n" + Util::printStacktrace());
			abort();
		});

		Database::init();

		#ifdef TEST_FLAG_WEBMON_ONLY
			// Run webserver in main thread, preventing further execution (frame collection and insertion is not performed in this mode)
			Webserver::init();
		#else
			thread([]{
				Webserver::init();
			}).detach();
		#endif

		while(true){
			//log("Time at start: " + to_string(Util::timeUs()));
			// Store isPrinting from previous frame; clear Frame and populate frame time
			//int64_t startTime = ;
			//int64_t lastTime = frame.time;
			bool wasPrinting = frame.isPrinting;
			int64_t startTime = Util::timeUs() / 1000 / 1000;
			// Check if we are keeping pace
			if(frame.time != 0 && startTime - frame.time != FRAME_COLLECTION_INTERVAL_S){
				log("Warning: Not keeping up with desired interval of " + to_string(FRAME_COLLECTION_INTERVAL_S) + ". Interval was: " + to_string(startTime - frame.time));
			}
			frame = {};
			frame.time = startTime;
			frame.wasPrinting = wasPrinting;

			// Data sources each fill Frame members
			Datasource::AuxTemp::fillFrame(frame);
			Datasource::RepRap::fillFrame(frame);

			// Collect stills only every 6th frame. At .1Hz, one still a minute.
			// TODO Consider using H.265 video to reduce data usage for still collection. How to implement this elegantly? Could chunks of data be written into each frame record in a bytea field? How would the performance be when having to stitch together 24hrs worth of frames? Can it be streamed over HTTP with seeking capability? Or is streaming to disk the only reasonable option? libavcodec could be used.
			if(frame.time % STILL_CAPTURE_INTERVAL == 0){
				// Record each 6th frame to reduce disk usage
				Datasource::Camera::fillFrame(frame);
			}

			// Insert frame into database
			Database::insertFrame(frame);

			// Unless we are in TEST_MODE_MOCK_INPUT, sleep based on time taken during this cycle
			#ifndef TEST_MODE_MOCK_INPUT
				// Substract time taken during cycle with target interval
				int64_t nextFrameTimeS = frame.time + FRAME_COLLECTION_INTERVAL_S;
				int64_t sleepTimeUs = (nextFrameTimeS * 1000 * 1000) - Util::timeUs();
				//log("next frame time:" + to_string(nextFrameTimeS) + " sleepTimeUs: " + to_string(sleepTimeUs));
				if(sleepTimeUs < 0){
					sleepTimeUs = 0;
				}
				//log("Time prior to sleep: " + to_string(Util::timeUs()));
				usleep(sleepTimeUs);
			#endif
		}
	}
}

