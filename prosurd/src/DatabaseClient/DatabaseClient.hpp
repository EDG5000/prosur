#pragma once

#include <postgresql/libpq-fe.h>

namespace Prosur::DatabaseClient{

bool init();

bool update(); // Reads prosurd::values. To be called each frame after all other clients have finished populating prosurd::values.

}
