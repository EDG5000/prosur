#pragma once

#include <string>
#include <map>

#include "Webserver/HTTPResponseBody.hpp"

using namespace std;

namespace Prosur::Webserver::Resources::Job{
	int run(HTTPResponseBody& responseBody, map<string,string> params);
}
