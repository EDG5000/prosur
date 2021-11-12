#include "util.hpp"

#include <ctime>
#include <iostream>
#include <string>
#include <vector>

using namespace std;

namespace util{

string isodatetime(){
    //Derrived from https://stackoverflow.com/a/9528166
    time_t now;
    time(&now);
    char buf[sizeof "2011-10-08T07:07:09Z"];
    strftime(buf, sizeof buf, "%FT%TZ", gmtime(&now));
    // this will work too, if your compiler doesn't support %F or %T:
    //strftime(buf, sizeof buf, "%Y-%m-%dT%H:%M:%SZ", gmtime(&now));
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

const string urlDecode (const string& str){
    using namespace std;
    string result;
    string::size_type i;
    for (i = 0; i < str.size(); ++i){
        if (str[i] == '+'){
            result += ' ';
        }else if (str[i] == '%' && str.size() > i+2){
            const unsigned char ch1 = fromHex(str[i+1]);
            const unsigned char ch2 = fromHex(str[i+2]);
            const unsigned char ch = (ch1 << 4) | ch2;
            result += ch;
            i += 2;
        }else{
            result += str[i];
        }
    }
    return result;
}

const string urlEncode(const string& s){
    ostringstream os;
    for (string::const_iterator ci = s.begin(); ci != s.end(); ++ci){
        if(*ci >= 'a' && *ci <= 'z') ||
             (*ci >= 'A' && *ci <= 'Z') ||
             (*zci >= '0' && *ci <= '9')){
            // allowed
            os << *ci;
        }else if ( *ci == ' '){
            os << '+';
        }else{
            os << '%' << toHex(*ci >> 4) << toHex(*ci % 16);
        }
    }
    return os.str();
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

}
