#pragma once

#include <map>
#include <vector>
#include <string>

using namespace std;

#include <postgresql/libpq-fe.h>

namespace Prosur::Database{

void init();

void update(); // Reads prosurd::values. To be called each frame after all other clients have finished populating prosurd::values.

// Data is stored here before being inserted into the database each frame.
// Keys match column names in the database.
// For decimal values, use hundreds, thousands etc.
// Database field comments document the unit and fraction of the value.
extern map<string, int32_t> numericValues;
extern map<string, vector<char>> binaryValues;

}
