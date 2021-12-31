#pragma once

#include <string>
#include <map>

using namespace std;

namespace Prosur::Webserver::Resources::File{
	int run(HTTPResponseBody& responseBody, map<string,string> params);
}
