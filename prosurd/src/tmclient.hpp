#pragma once

#include <map>

using namespace std;

namespace tmclient{

// Keyed by 64 bit temperature sensor rom
extern map<uint64_t, float> temperatures;

bool init();
bool update();

}

