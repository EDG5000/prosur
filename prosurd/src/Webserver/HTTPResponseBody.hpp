#pragma once

#include <string>
#include <vector>
#include <iostream>

#include "json.hpp"

using namespace std;
using namespace nlohmann;

namespace Prosur::Webserver{
	enum ContentType{
		Text,
		JPEG,
		JSON
	};

	// Allows flexible returning of a response body by assinging strings, binary data (char vector) a json objects.
	class HTTPResponseBody{
		// TODO content type is ambiguous; string could be binary or HTML (gcode vs html). Maybe stop using HTML, only use JSON?
		ContentType contentType = Text;
	public:
		vector<char> binaryData;
		string stringData;
		json jsonData;

		// Allows assigning by any of the supported types. Sets the type and value.
		HTTPResponseBody(){}; // Required to be present when used in std::map.
		HTTPResponseBody(string pStringData): stringData(pStringData), contentType(Text){}
		HTTPResponseBody(const char* pStringData): stringData(pStringData), contentType(Text){}
		HTTPResponseBody(vector<char> pBinaryData): binaryData(pBinaryData), contentType(JPEG){}
		HTTPResponseBody(json pJsonData): jsonData(pJsonData), contentType(JSON){
			stringData = pJsonData.dump(4);
		}

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

		string type(){
			switch(contentType){
			case JPEG:
				return "image/jpeg";
			case JSON:
				return "application/json;charset=UTF-8";
			case Text:
				return "text/plain";
			}
			return "";
		}
	};
}
