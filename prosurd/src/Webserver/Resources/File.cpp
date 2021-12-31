#include "Webserver/Resources/List.hpp"

#include <string>
#include <map>

#include "Webserver/Webserver.hpp"
#include "Util/Util.hpp"
#include "Database/Database.hpp"
#include "Database/DBUtil.hpp"

using namespace std;

namespace Prosur::Webserver::Resources::File{
	int run(string& responseData, map<string,string> parameters){
		responseData = "<h1>Not Implemented</h1>";
		cerr << "Not implemented" << endl;
		return HTTP_INTERNAL_SERVER_ERROR;
	}
}
