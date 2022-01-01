#include "AuxTemp/AuxTemp.hpp"

#include <vector>
#include <iostream>
#include <fstream>
#include <string>
#include <filesystem>

#include "json.hpp"


namespace Prosur::Datasource::AuxTemp{
	constexpr int SENSOR_COUNT = 8;

	// Keyed by 64 bit temperature sensor rom
	vector<int> temperatures; // Hundreds of degrees celcius

	bool init(){
		for(int i = 0; i < temperatures.size(); i++){
			temperatures[i] = i;
		}
		return true;
	}

	bool update(){
		for(int i = 0; i < temperatures.size(); i++){
			temperatures[i]++;
		}
		return true;
	}
}
