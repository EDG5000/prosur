#include <Datasource/RepRap/HTTPUtil.hpp>
#include <vector>
#include <iostream>
#include <fstream>
#include <string>
#include <filesystem>
#include <map>

#include "json.hpp"

#include <Util/Util.hpp>

using namespace std;
using namespace filesystem;
using namespace nlohmann;

namespace Prosur::Datasource::RepRap::HTTPUtil{
/*
 * http://theseus3.local/rr_connect?password=reprap&amp;time=2021-12-28T18%3A3%3A39": true
​
"http://theseus3.local/rr_fileinfo?name=0%3A%2Fgcodes%2FCFFFP_Electronics%20Box.gcode": true
​
"http://theseus3.local/rr_filelist?dir=0%3A%2Fgcodes%2F&amp;first=0": true
​
"http://theseus3.local/rr_filelist?dir=0%3A%2Fgcodes%2F&amp;first=48": true
​
"http://theseus3.local/rr_filelist?dir=0%3A%2Fgcodes&amp;first=0": true
​
"http://theseus3.local/rr_filelist?dir=0%3A%2Fgcodes&amp;first=48": true
​
"http://theseus3.local/rr_filelist?dir=0%3A%2Fmacros&amp;first=0": true
​
"http://theseus3.local/rr_gcode?gcode=M37%20P%220%3A%2Fgcodes%2FCFFFP_Electronics%20Box.gcode%22": true
rr_gcode?gcode=M37 P\"0:/gcodes/CFFFP_Electronics Box.gcode\"

"http://theseus3.local/rr_model?flags=d99fn": true
​
"http://theseus3.local/rr_model?key=inputs&amp;flags=d99vn": true
​
"http://theseus3.local/rr_model?key=job&amp;flags=d99vn": true
​
"http://theseus3.local/rr_model?key=volumes&amp;flags=d99vn": true
​
"http://theseus3.local/rr_reply": true
​
<prototype>: Object { … }
 */
	bool ready = false;
	map<string, vector<string>> responses; // Group requests by URL
	map<string, int> responseLastIndex; // Keep track of last index used in order to cycle through the dataset upon subsequent requests to the same URL

	// Extract relevant components from URI, enough to differentiate the different types of URLs
	static string identify(string url){
		vector<string> components = Util::strSplit(url, "/");
		url = components[components.size()-1];
		components = Util::strSplit(url, "?");
		string id = components[0];
		if(components.size() > 1){
			components = Util::strSplit(components[1], "&");
			// Sort parameter list to ensure consistent IDs, this avoids mismatches when parameter order between test dataset deviates from parameters generated by Datasource::RepRap
			sort(components.begin(), components.end());
			for(string& component: components){
				vector<string> keyVal = Util::strSplit(component, "=");
				string key = keyVal[0];
				string value = keyVal[1];
				id +=  "." + value;
			}

		}
		return id;
	}

	static void init(){
		// Load mock data HAR file exported from, for example, Firefox, containing HTTP requests made by DuetWebInterface over a period of time.
		// The requests where collected before, during and after clicking on the "Simulate" button on one of the gcode files
		// This has generated realistic output with values such as x and y position changing during the course of the
		// simulated print.

		string path = current_path().string() + "/testdata/mock_http_requests.har.json";
		//cout << "HTTPMock: init: loading from " << path << endl;
		ifstream file(path);
        stringstream buffer;
        buffer << file.rdbuf();
        string data = buffer.str();
        // Parse request log HAR file as JSON
		json log = json::parse(data);
		// Obtain log entries object
		json entries = log["log"]["entries"];
		// Add each response to correct vector within the map, keyed by response type
		int skipCount = 0;
		for(const auto& entry: entries){
			if(!entry.contains("response") || !entry["response"].contains("content") || !entry["response"]["content"].contains("text")){
				skipCount++;
				continue;
			}
			string id = identify(entry["request"]["url"]);
			string responseText = entry["response"]["content"]["text"];
			responses[id].push_back(responseText);
		}
	}

	string call(string url){
		if(!ready){
			init();
			ready = true;
		}
		// Return test file Gcode data if URL is identified as file download type
		if(url.find("rr_gcode") != string::npos){
			// Load and return test gcode
			string path = current_path().string() + "/testdata/testjob.gcode";
			ifstream file(path);
	        std::stringstream buffer;
	        buffer << file.rdbuf();
	        return buffer.str();
		}

		// Return from appropriate vector using appropriate last index
		// Increase the last index counter
		// Perform modulus operation to stay within vector range regardless of subsequent invocation count
		string id = identify(url);
		if(!responses.contains(id)){
			cerr << "HTTPUtilMock: No responses available for request with id " << id << " and URL: " << url << endl;
		}
		responseLastIndex[id]++;
		return responses[id][responseLastIndex[id] % responses[id].size()];
	}

}
