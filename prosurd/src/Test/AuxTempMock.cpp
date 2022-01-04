#include "Datasource/AuxTemp/AuxTemp.hpp"

#include <vector>
#include <iostream>
#include <fstream>
#include <string>
#include <filesystem>

#include "json.hpp"

#include "Database/Frame.hpp"

namespace Prosur::Datasource::AuxTemp{
	constexpr int SENSOR_COUNT = 8;

	// Keyed by 64 bit temperature sensor rom
	vector<int> temperatures; // Hundreds of degrees celcius

	bool ready = false;

	static void init(){
		for(int i = 0; i < temperatures.size(); i++){
			temperatures[i] = i;
		}
	}

	void fillFrame(Database::Frame& frame){ // Fill a part of the passed Frame
		if(!ready){
			init();
			ready = true;
		}

		for(int i = 0; i < temperatures.size(); i++){
			temperatures[i]++;
		}
	}
}
