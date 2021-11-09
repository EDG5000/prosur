#include <iostream>


#include <thread>

#include "rrfclient.hpp"

using namespace std;

int main() {
	bool was_printing = false;
	thread t{[=]{
			while(true){
				this_thread::sleep_for(1000ms);
				rrfclient::update();
				if(rrfclient::get_is_printing() && !was_printing){
					// Transition to printing
				}else if(!rrfclient::get_is_printing() && was_printing){
					// Transition to not printing
				}
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
