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

using namespace std;
using namespace Prosur;

namespace Prosur{

	// Microseconds between collection of a data frame
	constexpr int64_t FRAME_COLLECTION_INTERVAL = 1 * 1000 * 1000;

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

			// Data sources each fill Frame members
			Datasource::AuxTemp::fillFrame(frame);
			Datasource::RepRap::fillFrame(frame);
			Datasource::Camera::fillFrame(frame);

			// Insert frame into database
			Database::insertFrame(frame);

			// Unless we are in TEST_MODE, sleep based on time taken during this cycle
			#ifndef TEST_MODE
				// Substract time taken during cycle with target interval
				int64_t sleepTime = FRAME_COLLECTION_INTERVAL - ((time(NULL) - startTime) * 1000 * 1000);
				usleep(sleepTime);
			#endif
		}
	}

}

