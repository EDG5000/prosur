#pragma once

#include <vector>

using namespace std;

namespace prosurd::tmclient{

// Keyed by 64 bit temperature sensor rom
extern vector<int> temperatures; // Hundreds of degrees celcius

bool init();
bool update();

}

