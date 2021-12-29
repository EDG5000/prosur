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

namespace Prosur::RepRap::HTTPUtil{

	// Type of requests, as determined from URL either passed to HTTP or found in the requests log
	enum Type{
		Model,
		Job,
		File
	};

	bool ready = false;
	map<Type, vector<string>> responses;
	map<Type, int> responseLastIndex; // Keep track of last index used in order to cycle through the dataset upon subsequent requests

	static Type identify(string url){
		if(url.find("rr_model") != string::npos){
			if(url.find("job") != string::npos){
				// Downloading job object model
				return Job;
			}else{
				// Assume downloading base object model
				return Model;
			}
		}else{
			// Assume downloading a file
			return File;
		}
	}

	static void init(){
		// Load mock data HAR file exported from, for example, Firefox, containing HTTP requests made by DuetWebInterface over a period of time.
		// The requests where collected before, during and after clicking on the "Simulate" button on one of the gcode files
		// This has generated realistic output with values such as x and y position changing during the course of the
		// simulated print.

		string path = current_path().string() + "/testdata/mock_http_requests.har.json";
		cout << "HTTPMock: init: loading from " << path << endl;
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
			Type type = identify(entry["request"]["url"]);
			string responseText;
				if(!entry.contains("response") || !entry["response"].contains("content") || !entry["response"]["content"].contains("text")){
					skipCount++;
					continue;
				}
				responseText = entry["response"]["content"]["text"];

			//cout << responseText << endl;
			responses[type].push_back(responseText);
		}
		cout << "HTTPMock: Skipped " << skipCount << " unusable requests." << endl;
	}

	string call(string url){
		if(!ready){
			init();
			ready = true;
		}
		Type type = identify(url);

		//cerr << "Type: " << type << "URL: " << url << endl;

		// Return test file Gcode data if URL is identified as file download type
		if(type == File){
			// Load and return test gcode
			string path = current_path().string() + "/testdata/testjob.gcode";
			cout << "HTTPMock: call: loading file from " << path << endl;
			ifstream file(path);
	        std::stringstream buffer;
	        buffer << file.rdbuf();
	        return buffer.str();
		}

		// Return from appropriate vector using appriate last index
		// Increase the last index counter
		// Perform modulus operation to stay within vector range regardless of subsequent invocation count
		responseLastIndex[type]++;
		return responses[type][responseLastIndex[type] % responses[type].size()];
	}

}
