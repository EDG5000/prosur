#pragma once

#include <postgresql/libpq-fe.h>

namespace prosurd::dbclient{

constexpr int FORMAT_TEXT = 0;
constexpr int FORMAT_BINARY = 1;

extern PGconn* conn;

bool init();

bool update(); // Reads prosurd::values. To be called each frame after all other clients have finished populating prosurd::values.

}
