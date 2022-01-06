#pragma once

#include <vector>
#include <map>

#include "Database/DBValue.hpp"

using namespace std;

namespace Prosur::Database{
	// Is filled by the various Datasource functions before being passed to insertFrame
	class Frame{
	public:
		int64_t time; // Unix time second epoch in seconds; primary key of Frame
		int jobId;

		vector<char> jobFile;
		string jobFilename;
		int64_t jobFileModified; // -1 when not available

		// When isPrinting && !wasPrinting, a new uniqur jobId is generated and inserted into the database along with the Frame
		bool wasPrinting;
		bool isPrinting;

		vector<vector<char>> still; // JPEG stills

		vector<float> auxTemp;
		vector<float> heaterTemp;
		vector<float> cpuTemp;
		vector<float> inputVoltage;
		vector<float> motorPos; // May be used for x, y, z, e for now. Flexible.
		vector<int> endstop; // Suggested use: x-endstop, y-endstop, z-probe, filament runout sensor (x,y,z,e)
		vector<int> probe;

		float speedCurrentMms;
		float speedRequestedMms;
		int printLayersPrinted;
		int printLayersRemaining;
		float printProgressPercentage;

		void exportMap(map<string, DBValue>& values); // Used by toString and by Database when inserting into database
		string toString(); // Used when printing errors
	};
}
