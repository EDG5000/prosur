#pragma once

#include "json.hpp"

using namespace nlohmann;

namespace rrfclient{

// Reprap Object Model: https://github.com/Duet3D/RepRapFirmware/wiki/Object-Model-Documentation#overview
extern json rr_om;

// Blocking update call. Return within 250ms. Suggest calling at 1Hz.
void update();

}
