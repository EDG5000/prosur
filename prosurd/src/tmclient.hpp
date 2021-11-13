#pragma once

#include <map>

using namespace std;

namespace tmclient{

// Keyed by 64 bit temperature sensor rom
extern map<long unsigned int, float> temperatures;

bool init();
bool update();

}

