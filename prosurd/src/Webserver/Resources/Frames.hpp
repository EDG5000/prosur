#pragma once

#include <string>
#include <map>

using namespace std;
namespace Prosur::Webserver::Resources::Frames{
	int run(string& responseData, map<string,string> parameters);
}
