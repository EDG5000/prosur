#include <sys/time.h>
#include <Util/Util.hpp>

#include <time.h>
#include <dlfcn.h>
#include <cxxabi.h>
#include <execinfo.h>

#include <ctime>
#include <iostream>
#include <string>
#include <vector>
#include <fstream>
#include <regex>
#include <cstdlib>
#include <cstdio>
#include <string>
#include <sstream>
#include <iostream>

#include "Log.hpp"

using namespace std;

namespace Prosur::Util{

	int64_t rand(){ //140737349414545
		static bool ready;
		if(!ready){
			srand(time(NULL));
			ready = true;
		}
		return rand();
	}

	// Unix time in microseconds
	int64_t timeUs(){
		#ifdef TEST_MODE_MOCK_INPUT
			// When testing, no sleeping is done; each invocation, one second passes
			static int64_t time = Util::rand();
			time += 1000 * 1000;
			return time;
		#else
			struct timeval tv;
			gettimeofday(&tv,NULL);
			return tv.tv_sec*(uint64_t)1000000+tv.tv_usec;
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

	void writeDataToFileDebug(vector<uint8_t> data, string filename){
		ofstream out(filename, ios::out | ios::binary);
		out.write(reinterpret_cast<const char*>(data.data()), data.size());
		out.close();
	}

	string isodatetime(){
		tzset();
		time_t now;
		time(&now);
		char buf[16];
		strftime(buf, sizeof buf, "%b %d %H:%M:%S", localtime(&now));
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
		if(result == NULL){ // Should not be NULL and should point to the NUL byte at the end of the input string to mark a successfull full parse
			log("Error, unable to parse date string: " + dateTimeString);
			terminate();
		}
		return mktime(&datetime);
	}

	string decodeURIComponent(string encoded) {
		string decoded = encoded;
		smatch sm;
		string haystack;
		int dynamicLength = decoded.size() - 2;
		if (decoded.size() < 3) return decoded;
		for (int i = 0; i < dynamicLength; i++){
			haystack = decoded.substr(i, 3);
			if (regex_match(haystack, sm, regex("%[0-9A-F]{2}"))){
				haystack = haystack.replace(0, 1, "0x");
				string rc = {(char)stoi(haystack, nullptr, 16)};
				decoded = decoded.replace(decoded.begin() + i, decoded.begin() + i + 3, rc);
			}
			dynamicLength = decoded.size() - 2;
		}
		return decoded;
	}

	string encodeURIComponent(string decoded){
		ostringstream oss;
		regex r("[!'\\(\\)*-.0-9A-Za-z_~]");
		for (char &c : decoded){
			if (regex_match((string){c}, r)){
				oss << c;
			}else{
				oss << "%" << uppercase << hex << (0xff & c);
			}
		}
		return oss.str();
	}

	// TODO does not show symbol names of application code, only of stdlib
	// May need more adjustments to build system, or another approach
	string printStacktrace(){
		const int skip = 1;
		void *callstack[128];
		const int nMaxFrames = sizeof(callstack) / sizeof(callstack[0]);
		char buf[1024];
		int nFrames = backtrace(callstack, nMaxFrames);
		char **symbols = backtrace_symbols(callstack, nFrames);

		std::ostringstream trace_buf;
		for (int i = skip; i < nFrames; i++) {
			Dl_info info;
			if (dladdr(callstack[i], &info)) {
				char *demangled = NULL;
				int status;
				demangled = abi::__cxa_demangle(info.dli_sname, NULL, 0, &status);
				std::snprintf(
					buf,
					sizeof(buf),
					"%-3d %*p %s + %zd\n",
					i,
					(int)(2 + sizeof(void*) * 2),
					callstack[i],
					status == 0 ? demangled : info.dli_sname,
					(char *)callstack[i] - (char *)info.dli_saddr
				);
				free(demangled);
			} else {
				std::snprintf(buf, sizeof(buf), "%-3d %*p\n",
					i, (int)(2 + sizeof(void*) * 2), callstack[i]);
			}
			trace_buf << buf;
			std::snprintf(buf, sizeof(buf), "%s\n", symbols[i]);
			trace_buf << buf;
		}
		free(symbols);
		if (nFrames == nMaxFrames)
			trace_buf << "[truncated]\n";
		return trace_buf.str();
	}
}
