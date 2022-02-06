#pragma once

#include <string>
#include <map>

#include "Webserver/HTTPResponseBody.hpp"

using namespace std;

namespace Prosur::Webserver::Resources::Jobs{
	int run(string resource, HTTPResponseBody& responseBody, map<string,string> params);
}
