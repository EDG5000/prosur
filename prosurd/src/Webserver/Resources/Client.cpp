/*
 * Webserver resource: Client
 * Will serve a HTML resource containing all the needed JavaScript, HTML and CSS code inline for the client to view the data prosurd has collected.
 */

#include "Webserver/Resources/Client.hpp"

#include <map>
#include <string>
#include <vector>
#include <iostream>
#include <fstream>
#include <streambuf>
#include <sstream>
#include <ctime>
#include <climits>
#include <filesystem>

#include "Webserver/Webserver.hpp"
#include "Util/Util.hpp"
#include "Database/Database.hpp"
#include "Database/DBUtil.hpp"
#include "Log.hpp"

using namespace std;
using namespace filesystem;

namespace Prosur::Webserver::Resources::Client{
	int run(string resource, HTTPResponseBody& responseBody, map<string,string> params){
		if(resource == ""){
			resource = "index.html";
		}
		ifstream file(current_path().string() + "/../webmon/" + resource);
		stringstream buffer;
		buffer << file.rdbuf();
		string fileData = buffer.str();
		string extension = resource.substr(resource.find(".") + 1);
		ContentType contentType;
		if(extension == "css"){
			contentType = CSS;
		}else if(extension == "js"){
			contentType = JavaScript;
		}else if(extension == "html"){
			contentType = HTML;
		}else{
			contentType = Text;
		}
		responseBody = HTTPResponseBody(fileData, contentType);
		return HTTP::OK;
	}
}
