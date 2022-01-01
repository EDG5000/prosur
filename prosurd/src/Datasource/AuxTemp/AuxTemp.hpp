#pragma once

#include <vector>

#include "Database/Database.hpp"

using namespace std;

namespace Prosur::Datasource::AuxTemp{
	void init();
	void fillFrame(Database::Frame& frame); // Fill a part of the passed Frame
}

