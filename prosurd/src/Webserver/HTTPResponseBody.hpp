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
		HTML,
		JPEG,
		JSON,
		CSS,
		JavaScript
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
		// By default, assigning a HTTPResponseBody instance with a string will result in a text/plain response body (due to automatic implicit conversion)
		// Caller can explicity invoke constructor and set the "html" flag high, this will set the content type to text/html
		HTTPResponseBody(string pStringData, ContentType pContentType = Text): stringData(pStringData){
			contentType = pContentType;
		}
		// Initialize with c-string
		HTTPResponseBody(const char* pStringData): stringData(pStringData), contentType(Text){}
		// Initialize with binary data using vector<char>. Assumed to be JPEG data.
		HTTPResponseBody(vector<char> pBinaryData): binaryData(pBinaryData), contentType(JPEG){}
		// Initialize with json object. Will be serialized immediately. Content type will be application/json
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
			case HTML:
				return "text/html";
			case CSS:
				return "text/css";
			case JavaScript:
				return "text/javascript";
			}
			return "";
		}
	};
}
