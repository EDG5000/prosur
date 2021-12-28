#pragma once

#include <vector>
#include <string>

#include "json.hpp"

using namespace nlohmann;
using namespace std;

namespace prosurd::rrfclient{

// Reprap Object Model: https://github.com/Duet3D/RepRapFirmware/wiki/Object-Model-Documentation#overview
extern json om;
extern vector<char> lastJobFile; // Updated when transitioned to printing state from previous non-printing state (or when first frame after init is in printing state).

// Blocking update call. Return within 250ms. Suggest calling at 1Hz.
bool update();

// Obtain data obout current state of om object
bool is_printing();
bool was_printing(); // Value of is_printing of the previous frame. Returns false on first frame.
vector<float> get_temperatures();
string get_current_job_filename();
int64_t get_current_job_modified();

}
