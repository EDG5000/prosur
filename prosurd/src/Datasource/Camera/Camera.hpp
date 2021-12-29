#pragma once

#include <stdint.h>

#include <vector>

using namespace std;

namespace Prosur::Datasource::Camera{

extern vector<uint8_t> image;

void update();

}
