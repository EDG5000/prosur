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
		vector<float> auxTemp;
		vector<char> jobFile;
		vector<vector<char>> still; // JPEG stills
		vector<float> heaterTemp;
		float cpuTemp;
		bool wasPrinting;
		bool isPrinting;
		string jobFilename;
		int64_t jobFileModified; // -1 when not available
		vector<float> motorPos; // May be used for x, y, z, e for now. Flexible.
		float inputVoltage;
		float probeX; // May be used for. X endstop
		float probeY; // May be used Y endstop
		float probeZ; // May be used for z-probe or endstop
		float probeE; // May be used for filament runout sensor
		float speedCurrentMms;
		float speedRequestedMms;
		int printLayersPrinted;
		int printLayersRemaining;
		float printProgressPercentage;
	};

	// These values are important for correctly inserting the frame data
	namespace KEY{
		const string IS_PRINTING = "is_printing";
		const string JOB_FILE_NAME = "job_file_name";
		const string JOB_FILE_MODIFIED = "job_file_modified";
	}

	void init();
	void insertFrame(Frame& frame);
}
