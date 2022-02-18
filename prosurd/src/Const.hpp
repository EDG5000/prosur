#pragma once

#include <inttypes.h>

namespace Prosur{

	// Microseconds between collection of a data frame
	constexpr int64_t FRAME_COLLECTION_INTERVAL_S = 1; // 1s
	constexpr int64_t STILL_CAPTURE_INTERVAL = 6; // Capture a still each 6th second

}
