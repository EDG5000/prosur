#pragma once

#include <stdint.h>

#include <vector>

using namespace std;

namespace Prosur::CameraClient{

extern vector<uint8_t> image;

bool update();

}
