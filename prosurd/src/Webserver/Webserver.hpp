#pragma once

#include <vector>
#include <string>

using namespace std;

namespace Prosur::Webserver{
	namespace HTTP{
		constexpr int OK = 200;
		constexpr int BAD_REQUEST = 400;
		constexpr int NOT_FOUND = 404;
		constexpr int INTERNAL_SERVER_ERROR = 500;
	}

	void init();
}
