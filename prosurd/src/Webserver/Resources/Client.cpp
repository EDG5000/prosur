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

using namespace std;
using namespace filesystem;

namespace Prosur::Webserver::Resources::Client{
	int run(HTTPResponseBody& responseBody, map<string,string> params){

		std::ifstream t(current_path().string() + "/client.html");
		std::stringstream buffer;
		buffer << t.rdbuf();
		string htmlData = buffer.str();
		responseBody = HTTPResponseBody(htmlData, true);

		return HTTP::OK;
	}
}
