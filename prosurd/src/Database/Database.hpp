#pragma once

#include <map>
#include <vector>
#include <string>

#include <postgresql/libpq-fe.h>

#include "Database/DBValue.hpp"
#include "Database/Frame.hpp"

using namespace std;

namespace Prosur::Database{
	void init();
	void insertFrame(Frame& frame);
}
