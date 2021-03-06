#pragma once

#include <string>
#include <vector>

using namespace std;

namespace Prosur::Util{
	int64_t timeUs();  // Unix time in microseconds
	void swapbytes(char* inp, size_t len);
	string isodatetime(); // Generate ISO datetime string from current time
	//string isodatetime(int64_t timestamp); // Generate ISO datetime string from unix timestamp in seconds as parameter
	vector<string> strSplit(string str, string delim);
	void replaceAll(string& str, const string& from, const string& to);
	string decodeURIComponent(string encoded);
	string encodeURIComponent(string decoded);
	string join(const vector<string>& elems, string delim);
	uint64_t getTimeMillis();
	void writeDataToFileDebug(vector<uint8_t> data, string filename);
	int64_t parseDateTimeString(string dateTimeString);
	int64_t rand();
	string printStacktrace();
}
