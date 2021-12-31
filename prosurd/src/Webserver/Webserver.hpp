#pragma once

#include <vector>
#include <string>

using namespace std;

namespace Prosur::Webserver{
	constexpr int HTTP_OK = 200;
	constexpr int HTTP_BAD_REQUEST = 400;
	constexpr int HTTP_NOT_FOUND = 404;
	constexpr int HTTP_INTERNAL_SERVER_ERROR = 500;

	void init();
}
