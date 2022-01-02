#pragma once

#include <stdint.h>

#include <vector>

#include "Database/Database.hpp"

using namespace std;

namespace Prosur::Datasource::Camera{
	void fillFrame(Database::Frame& frame); // Fill a part of the passed Frame
}
