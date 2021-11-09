#include "rrfclient.hpp"

#include "httplib.hpp"
#include "json.hpp"

#include "util.hpp"

using namespace std;
using namespace nlohmann;

namespace rrfclient{

//http://192.168.2.15/rr_connect?password=amirgay0511&time=2021-11-8T18:9:31
// rr_connect?password=XXX&time=YYY
// or: //http://192.168.2.15/rr_model?flags=d99fn
// http://192.168.2.15/rr_download?name=0:/gcodes/CFFFP_Electronics Box.gcode

json rr_om;

// Blocking update call. Return within 250ms. Suggest calling at 1Hz.
void update(){
	httplib::Client client("http://192.168.2.15");
	auto response = client.Get("rr_model?flags=d99fn");
	if(response->status != 200){
		cout << "Got HTTP" << response->status << endl;
		return;
	}

	rr_om = json::parse(response->body);
	std::cout << rr_om.dump();
	//temp[0-2] = result.heat.heaters[0-2].current
	//isPrinting = result.job.build == null
	//result.file.fileName
}

}
