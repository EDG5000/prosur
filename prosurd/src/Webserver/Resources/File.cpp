#include "Webserver/Resources/List.hpp"

#include <string>
#include <map>

#include "Webserver/Webserver.hpp"
#include "Util/Util.hpp"
#include "Database/Database.hpp"
#include "Database/DBUtil.hpp"

using namespace std;

namespace Prosur::Webserver::Resources::File{
	int run(HTTPResponseBody& responseBody, map<string,string> params){
		responseBody.stringData = "Not Implemented";
		cerr << responseBody.stringData << endl;
		return HTTP_INTERNAL_SERVER_ERROR;
	}
}
