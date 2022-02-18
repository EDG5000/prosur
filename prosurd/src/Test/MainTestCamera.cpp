#include <unistd.h>

#include <iostream>
#include <fstream>
#include <filesystem>
#include <string>

#include "Datasource/Camera/Camera.hpp"
#include "Database/Frame.hpp"
#include "Log.hpp"

using namespace std;
using namespace filesystem;

namespace Prosur{

	extern "C" int main(){

		log("Hello.");

		Database::Frame frame;
		int iteration = 0;

		while(true){
			log("Iteration " + to_string(iteration));
			frame = {};
			Datasource::Camera::fillFrame(frame);

			log("Writing " + to_string(frame.still[0].size()));
			if(frame.still[0].size() > 0){
				auto file = std::fstream(current_path().string() + "/testdata/camera-output/captured-image-" + to_string(iteration) + ".jpg", std::ios::out | std::ios::binary);
				file.write((char*)&frame.still[0][0], frame.still[0].size());
				file.close();
			}

			log("Done. Sleeping");

			iteration++;
			usleep(1000 * 1000); // 1s
		}

		return 0;
	}

}
