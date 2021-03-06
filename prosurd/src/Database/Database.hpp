#pragma once

#include <map>
#include <vector>
#include <string>

#include <libpq-fe.h>

#include "Database/DBValue.hpp"
#include "Database/Frame.hpp"

using namespace std;

namespace Prosur::Database{
	void init();
	void insertFrame(Frame& frame);

	extern map<string, string> frameColumnTypes; // Currently only read by Webserver::Resource::Frames
}
