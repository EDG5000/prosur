#include "Log.hpp"

#include <string>
#include <mutex>
#include <iostream>

#include "Util/Util.hpp"

using namespace std;

// Declared in global Prosur namespace to avoid clutter
namespace Prosur{
	mutex logMutex;

	void log(string line){
		logMutex.lock();
		cerr << "[" << Util::isodatetime() << "] " << line << endl;
		logMutex.unlock();
	}
}
