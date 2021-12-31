#pragma once

#include <string>
#include <map>

using namespace std;

namespace Prosur::Webserver::Resources::File{
	int run(string& responseData, map<string,string> parameters);
}
