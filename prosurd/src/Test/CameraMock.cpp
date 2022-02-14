#include "Datasource/Camera/Camera.hpp"

#include <iostream>
#include <istream>
#include <fstream>
#include <filesystem>

#include "Database/Frame.hpp"
#include "Main.hpp"

using namespace std;
using namespace filesystem;

namespace Prosur::Datasource::Camera{

	vector<char> image;

	bool ready = false;

	static void init(){
		string path = current_path().string() + "/testdata/testimage.jpg";
		ifstream file(path);


	    copy(istreambuf_iterator<char>(file), istreambuf_iterator<char>(), back_inserter(image));
	}

	void fillFrame(Database::Frame& frame){
		if(!ready){
			init();
			ready = true;
		}
		frame.still.push_back(image);
	}
}
