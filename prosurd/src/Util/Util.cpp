#include <sys/time.h>
#include <Util/Util.hpp>

#include <ctime>
#include <iostream>
#include <string>
#include <vector>
#include <fstream>

#include <time.h>

using namespace std;

namespace Prosur::Util{

	int64_t unixTime(){
		#ifdef TEST_MODE
			// When testing, no sleeping is done; each invocation, one second passes
			static int64_t time;
			time++;
			return time;
		#else
			return time(NULL);
		#endif
	}

	void swapbytes(char* inp, size_t len){
	    unsigned int i;
	    unsigned char* in = (unsigned char *)inp,tmp;

	    for(i=0;i<len/2;i++) {
	        tmp=*(in+i);
	        *(in+i)=*(in+len-i-1);
	        *(in+len-i-1)=tmp;
	    }
	}

	//Derrived from https://stackoverflow.com/a/68367878
	void writeDataToFileDebug(vector<uint8_t> data, string filename){
		std::ofstream out(filename, std::ios::out | std::ios::binary);
		out.write(reinterpret_cast<const char*>(data.data()), data.size());
		out.close();
	}

	string isodatetime(int64_t timestamp){
		struct tm* timeinfo = localtime(&timestamp);
		char buf[sizeof "2011-10-08T07:07:09Z"];
		strftime(buf, sizeof buf, "%FT%TZ", localtime(&timestamp));
		return buf;
	}

	// Derrived from https://stackoverflow.com/a/9528166
	string isodatetime(){
		time_t now;
		time(&now);
		char buf[sizeof "2011-10-08T07:07:09Z"];
		strftime(buf, sizeof buf, "%FT%TZ", gmtime(&now));
		return buf;
	}

	vector<string> strSplit(string str, string delim){
		vector<string> segments;
		string::size_type beg = 0;
		for (size_t end = 0; (end = str.find(delim, end)) != string::npos; ++end){
			segments.push_back(str.substr(beg, end - beg));
			beg = end + 1;
		}
		segments.push_back(str.substr(beg));
		return segments;
	}

	void replaceAll(string& str, const string& from, const string& to){
		if(from.empty()){
			return;
		}
		size_t start_pos = 0;
		while((start_pos = str.find(from, start_pos)) != string::npos){
			str.replace(start_pos, from.length(), to);
			start_pos += to.length(); // In case 'to' contains 'from', like replacing 'x' with 'yx'
		}
	}

	string join(const vector<string>& elems, string delim){
		string s;
		for (vector<string>::const_iterator ii = elems.begin(); ii != elems.end(); ++ii){
			s += (*ii);
			if ( ii + 1 != elems.end() ) {
				s += delim.c_str();
			}
		}
		return s;
	}

	uint64_t getTimeMillis(){
		struct timeval tp;
		gettimeofday(&tp, NULL);
		uint64_t ms = tp.tv_sec * 1000 + tp.tv_usec / 1000;
		return ms;
	}

	// Parse date/time strings as they are found in RepRapFirmware JSON data
	int64_t parseDateTimeString(string dateTimeString){
		// e.g. 2021-07-25T23:25:34
		tm datetime = {};
		char* result = strptime(dateTimeString.c_str(), "%Y-%m-%dT%H:%M:%S", &datetime);
		if(result != NULL){ // Should not be NULL and should point to the NUL byte at the end of the input string to mark a successfull full parse
			cerr << "Error, unable to parse date string: " << dateTimeString << " (failed at character " << result-dateTimeString.c_str() << *result << ")" << endl;
		}
		return mktime(&datetime);
	}
}
