#include "JobFile/JobFile.hpp"

#include <string>
#include <map>
#include <iostream>

#include "Util/Util.hpp"

namespace Prosur::JobFile::Extractor::PrusaSlicer{

	const string START_MARKER = "; prusaslicer_config = begin";

	map<string, string> extractParameters(string& fileData){
		// Find part in file where parameters start (last section of the file)
		int start = fileData.find(START_MARKER);
		if(start == string::npos){
			cerr << "JobFile::Extractor::PrusaSlicer: Unable to find parameter start marker: " + START_MARKER << " file size: " + to_string(fileData.size()) << endl;
			terminate();
		}

		// Split into lines
		const string parameterSource = fileData.substr(start, string::npos);
		const vector<string> lines = Util::strSplit(parameterSource, "\n");
		if(lines.size() < 2){
			cerr << "JobFile::Extractor::PrusaSlicer: Expected at least two lines in the parameter section. Section: " << parameterSource << " Line count: " << to_string(lines.size()) << endl;
			terminate();
		}

		// Parse lines into map
		map<string, string> outputMap;
		for(const string& line: lines){
			vector<string> components = Util::strSplit(line, " = ");
			if(components.size() != 2){
				continue;
			}
			// Trim comment, space and newline from key and value
			Util::replaceAll(components[0], "; ", "");
			Util::replaceAll(components[1], "\n", "");
			Util::replaceAll(components[1], "= ", "");
			if(components[1].size() == 0 || components[0].size() == 0){
				continue;
			}
			// Store key and value
			outputMap[components[0]] = components[1];
		}
		if(outputMap.size() == 0){
			cerr << "ParameterExtractor: Expected output map size to be larger than zero. Source string: " << parameterSource << endl;
			terminate();
		}
		return outputMap;
	}
}
