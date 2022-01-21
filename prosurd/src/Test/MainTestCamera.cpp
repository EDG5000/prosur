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

		cout << "Hello." << endl;

		Database::Frame frame;
		vector<char>& data = frame.still[0];
		int iteration = 0;

		while(true){
			cout << "Iteration " << to_string(iteration) << endl;
			frame = {};
			Datasource::Camera::fillFrame(frame);

			cout << "Writing " << to_string(data.size()) << endl;
			if(data.size() > 0){
				auto file = std::fstream(current_path().string() + "/testdata/camera-output/captured-image-" + to_string(iteration) + ".jpg", std::ios::out | std::ios::binary);
				file.write((char*)&data[0], data.size());
				file.close();
			}

			cout << "Done. Sleeping" << endl;

			iteration++;
			usleep(1000 * 1000); // 1s
		}

		return 0;
	}

}
