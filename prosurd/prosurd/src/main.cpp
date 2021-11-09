#include <iostream>


#include <thread>

#include "rrfclient.hpp"

using namespace std;

int main() {
	thread t{[]{
			while(true){
				this_thread::sleep_for(1000ms);
				rrfclient::update();
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
