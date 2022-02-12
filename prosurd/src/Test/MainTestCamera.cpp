#include <unistd.h>

#include <iostream>
#include <fstream>
#include <filesystem>
#include <string>

#include "Datasource/Camera/Camera.hpp"
#include "Database/Frame.hpp"

using namespace std;
using namespace filesystem;

namespace Prosur{

	extern "C" int main(){

		cerr << "Hello." << endl;

		Database::Frame frame;
		int iteration = 0;

		while(true){
			cerr << "Iteration " << to_string(iteration) << endl;
			frame = {};
			Datasource::Camera::fillFrame(frame);

			cerr << "Writing " << to_string(frame.still[0].size()) << endl;
			if(frame.still[0].size() > 0){
				auto file = std::fstream(current_path().string() + "/testdata/camera-output/captured-image-" + to_string(iteration) + ".jpg", std::ios::out | std::ios::binary);
				file.write((char*)&frame.still[0][0], frame.still[0].size());
				file.close();
			}

			cerr << "Done. Sleeping" << endl;

			iteration++;
			usleep(1000 * 1000); // 1s
		}

		return 0;
	}

}
