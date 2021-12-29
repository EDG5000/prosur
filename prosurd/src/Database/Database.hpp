#pragma once

#include <postgresql/libpq-fe.h>

namespace Prosur::Database{

void init();

void update(); // Reads prosurd::values. To be called each frame after all other clients have finished populating prosurd::values.

}
