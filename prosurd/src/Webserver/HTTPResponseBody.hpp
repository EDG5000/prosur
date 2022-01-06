#pragma once

#include <string>
#include <vector>
#include <iostream>

using namespace std;

namespace Prosur::Webserver{
	enum HTTPResponseType{
		String,
		Binary
	};

	// Allows flexible passing of parameters along with query
	// vector<Param> can be used as parameter like so:
	// myfunc({1, 3423434, "string", myCharVector})
	class HTTPResponseBody{
		//HTTPResponseType type = String;
	public:
		vector<char> binaryData;
		string stringData;

		// Allows assigning by any of the supported types. Sets the type and value.
		HTTPResponseBody(){}; // Required to be present when used in std::map.
		HTTPResponseBody(string pStringData): stringData(pStringData){}
		HTTPResponseBody(const char* pStringData): stringData(pStringData){}
		HTTPResponseBody(vector<char> pBinaryData): binaryData(pBinaryData){}

		friend ostream& operator<<(ostream& os, const HTTPResponseBody& dt){
		    os << dt.stringData;
		    return os;
		}

		HTTPResponseBody& operator += (const HTTPResponseBody& rhs){
			stringData += rhs.stringData;
		   return *this;
		}

		// Allows obtaining as raw data pointer (see size())
		operator char*() const{
			if(stringData.size() > 0){
				return (char*) stringData.data();
			}else{
				return (char*) binaryData.data();
			}
		}

		// To use in conjuction with operator const char* when obtaining raw data.
		int size() const{
			if(stringData.size() > 0){
				return stringData.size();
			}else{
				return binaryData.size();
			}
			return 0;
		}
	};
}
