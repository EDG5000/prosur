/*
 * Prosur: Production Surveyor
 * Logs all activity in your additive production facility.
 */

#include <thread>
#include <map>
#include <iostream>
#include <ctime>

#include <inttypes.h>
#include <unistd.h>

#include "Datasource/Camera/Camera.hpp"
#include "Datasource/RepRap/RepRap.hpp"
#include "Datasource/AuxTemp/AuxTemp.hpp"
#include "Database/Database.hpp"
#include "Webserver/Webserver.hpp"
#include "Util/Util.hpp"
#include "Database/Frame.hpp"

using namespace std;
using namespace Prosur;

namespace Prosur{

	// Microseconds between collection of a data frame
	constexpr int64_t FRAME_COLLECTION_INTERVAL = 10 * 1000 * 1000;

	Database::Frame frame;

	extern "C" int main() {
		Webserver::init();
		Database::init();

		while(true){
			int64_t startTime = Util::unixTime();

			// Store isPrinting from previous frame; clear Frame and populate frame time
			bool wasPrinting = frame.isPrinting;
			frame = {};
			frame.time = startTime;
			frame.wasPrinting = wasPrinting;

			/*
			// Data sources each fill Frame members
			Datasource::AuxTemp::fillFrame(frame);
			Datasource::RepRap::fillFrame(frame);
			// Collect stills only every 6th frame. At .1Hz, one still a minute.
			// TODO Use H.265 video to reduce data usage for still collection. How to implement this elegantly? Could chunks of data be written into each frame record in a bytea field? How would the performance be when having to stitch together 24hrs worth of frames? Can it be streamed over HTTP with seeking capability? Or is streaming to disk the only reasonable option? libavcodec could be used.
			if(frame.time % 6 == 0){
				Datasource::Camera::fillFrame(frame);
			}


			// Insert frame into database
			Database::insertFrame(frame);
*/

			// Unless we are in TEST_MODE, sleep based on time taken during this cycle
			#ifndef TEST_MODE
				// Substract time taken during cycle with target interval
				int64_t timeTaken = time(NULL) - startTime;
				int64_t sleepTime = FRAME_COLLECTION_INTERVAL - timeTaken;
				if(sleepTime < 0){
					cerr << "warning: taking " << (sleepTime * -1) << "us too long to keep up with desired " << FRAME_COLLECTION_INTERVAL << "us interval. Operating at reduced frame collection rate." << endl;
					sleepTime = 0;
				}
				usleep(sleepTime);
			#endif
		}
	}
}

