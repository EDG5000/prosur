#pragma once

#include <string>
#include <vector>

using namespace std;

namespace util{

string isodatetime();
vector<string> strSplit(string str, string delim);
void replaceAll(string& str, const string& from, const string& to);
const string urlDecode (const string& str);
const string urlEncode(const string& s);
string join(const vector<string>& elems, string delim);
uint64_t getTimeMillis();

}
