#pragma once

#include <string>
#include <map>

using namespace std;

namespace prosurd{

// Data is stored here before being inserted into the database each frame. The keys need to match column names in the database. For decimal values, use hundreds, thousands etc. The comment field in the database needs to document the unit and fraction of the value.
extern map<string, int32_t> values;
extern int64_t time;

}
