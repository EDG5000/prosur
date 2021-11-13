#pragma once

#include <stdint.h>

#include <vector>

using namespace std;

namespace cclient{

extern vector<uint8_t> image;

bool init();
bool update();

}
