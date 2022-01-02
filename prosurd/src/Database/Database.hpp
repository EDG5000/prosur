#pragma once

#include <map>
#include <vector>
#include <string>

#include <postgresql/libpq-fe.h>

#include "Database/DBValue.hpp"

using namespace std;

namespace Prosur::Database{
	// Is filled by the various Datasource functions before being passed to insertFrame
	struct Frame{
		int64_t time; // Unix time second epoch in seconds; primary key of Frame

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
		vector<float> endstop; // Suggested use: x-endstop, y-endstop, z-probe, filament runout sensor (x,y,z,e)
		vector<float> probe;

		float speedCurrentMms;
		float speedRequestedMms;
		int printLayersPrinted;
		int printLayersRemaining;
		float printProgressPercentage;
	};

	void init();
	void insertFrame(Frame& frame);
}
