#pragma once

#include <vector>

#include "Database/Frame.hpp"

using namespace std;

namespace Prosur::Datasource::AuxTemp{
	void fillFrame(Database::Frame& frame); // Fill a part of the passed Frame
}

