#pragma once

#include <string>
#include <map>

using namespace std;

namespace Prosur::JobFile::Extractor::PrusaSlicer{
	map<string, string> extractParameters(string& fileData);
}
