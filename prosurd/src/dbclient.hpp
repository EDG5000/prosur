#pragma once

namespace prosurd::dbclient{

bool init();

bool update(); // Reads prosurd::values. To be called each frame after all other clients have finished populating prosurd::values.

}
