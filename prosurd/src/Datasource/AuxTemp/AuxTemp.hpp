#pragma once

#include <vector>

using namespace std;

namespace Prosur::Datasource::AuxTemp{

// Keyed by 64 bit temperature sensor rom
extern vector<int> temperatures; // Hundreds of degrees celcius

void init();
void update();

}

