#pragma once

#include <vector>
#include <string>

#include "json.hpp"

#include "Database/Frame.hpp"

using namespace std;

namespace Prosur::Datasource::RepRap{
	extern string hostname;
	void fillFrame(Database::Frame& frame); // Fill a part of the passed Frame
}
