#pragma once

#include <vector>
#include <string>

#include "json.hpp"

using namespace nlohmann;
using namespace std;

namespace rrfclient{

// Reprap Object Model: https://github.com/Duet3D/RepRapFirmware/wiki/Object-Model-Documentation#overview
extern json om;

// Blocking update call. Return within 250ms. Suggest calling at 1Hz.
bool update();

// Obtain data obout current state of om object
bool get_is_printing();
vector<float> get_temperatures();
string get_filename();

}
