#pragma once

#include <string>
#include <map>

using namespace std;

namespace Prosur::JobFile{

	map<string, string> extractParameters(string& fileData);
}
