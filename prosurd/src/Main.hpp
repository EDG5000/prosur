#pragma once

#include <string>
#include <map>

using namespace std;

namespace Prosur{

// Data is stored here before being inserted into the database each frame.
// Keys match column names in the database.
// For decimal values, use hundreds, thousands etc.
// Database field comments document the unit and fraction of the value.
extern map<string, int32_t> values;

// Updated at the beginning of the tick by Main. Used elsewhere to determine time of current frame.
extern int64_t time;

}
