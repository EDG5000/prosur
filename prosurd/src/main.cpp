#include <iostream>


#include <thread>

#include "rrfclient.hpp"

using namespace std;

int main() {
	bool was_printing = false;
	thread t{[=]{
			while(true){
				// TODO Update chamber temperatures
				tmclient::update();


				rrfclient::update();
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

				cout << "Joinable std::thread" << '\n';
			}
	}};

	cout << "OPJoinable std::thread" << '\n';
	cout << "Joinable std::thread" << '\n';
	while(true){
		this_thread::sleep_for(1000ms);
	}
	return 0;
}
