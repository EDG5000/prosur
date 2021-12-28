#pragma once

#include <vector>

using namespace std;

namespace Prosur::AuxTemp{

// Keyed by 64 bit temperature sensor rom
extern vector<int> temperatures; // Hundreds of degrees celcius

bool init();
bool update();

}

