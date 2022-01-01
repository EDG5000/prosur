#pragma once

#include <vector>
#include <string>

#include "json.hpp"

#include "Database/Database.hpp"

using namespace std;

namespace Prosur::Datasource::RepRap{
	void fillFrame(Database::Frame& frame); // Fill a part of the passed Frame
}
