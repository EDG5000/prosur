#include <iostream>

#include <thread>

#include "rrfclient.hpp"
#include "tmclient.hpp"

using namespace std;

constexpr auto cyleTime = 1000ms;

int main() {
	bool was_printing = false;
	//thread t{[=]{
			while(true){
				// TODO Update chamber temperatures
				tmclient::update();
				if(!rrfclient::update()){
					cerr << "main: rrfclient experienced failure. skipping cycle." << endl;
					this_thread::sleep_for(cyleTime);
					continue;
				}
				if(rrfclient::get_is_printing() && !was_printing){
					// Transition to printing
					// Insert job, get ID back, store ID globally
				}else if(!rrfclient::get_is_printing() && was_printing){
					// Transition to not printing
					// Set JOB id to NULL
				}else if(rrfclient::get_is_printing()){
					// Printing, no transition
				}

				// Store properties of rrclient_om and tmclient_om in frames table
				this_thread::sleep_for(cyleTime);
			}
	//}};

	//while(true){
	//	this_thread::sleep_for(1000ms);
	//}
	return 0;
}
