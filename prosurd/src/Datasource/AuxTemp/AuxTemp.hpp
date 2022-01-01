#pragma once

#include <vector>

using namespace std;

namespace Prosur::Datasource::AuxTemp{

extern vector<int> temperatures; // Hundreds of degrees celcius

void init();
void update();

}

