#include "Datasource/Camera/Camera.hpp"

#include <iostream>
#include <istream>
#include <fstream>
#include <strstream>
#include <filesystem>

using namespace std;
using namespace filesystem;

namespace Prosur::Datasource::Camera{

	vector<uint8_t> image;

	bool ready = false;

	static void init(){
		string path = current_path().string() + "/testdata/testimage.jpg";
		ifstream file(path);
		image << file;
	}

	void fillFrame(Database::Frame& frame){
		if(!ready){
			init();
			ready = true;
		}
		frame.still[0] = move(image);
	}
}
