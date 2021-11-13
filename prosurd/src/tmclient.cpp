#include "tmclient.hpp"

#include <fcntl.h>
#include <stdio.h>
#include <unistd.h>
#include <stdint.h>
#include <termios.h>
#include <errno.h>
#include <stdlib.h>
#include <string.h>

#include <thread>
#include <string>
#include <iostream>
#include <map>
#include <vector>

#include "util.hpp"

using namespace std;

namespace tmclient{

const string DEVICE_NAME = "/dev/ttyUSB0";

map<long unsigned int, float> temperatures;
string readBuffer;
int fd;

bool init(){
    fd = open(DEVICE_NAME.c_str(), O_RDWR | O_NOCTTY | O_SYNC);
    if (fd < 0) {
        printf("Error opening %s: %s\n", DEVICE_NAME.c_str(), strerror(errno));
        return false;
    }

    struct termios tty;

    if (tcgetattr(fd, &tty) < 0) {
        printf("Error from tcgetattr: %s\n", strerror(errno));
        return false;
    }

    // Baudrate 9600, 8 bits, no parity, 1 stop bit
    cfsetospeed(&tty, B9600);
    cfsetispeed(&tty, B9600);

    tty.c_cflag |= CLOCAL | CREAD;
    tty.c_cflag &= ~CSIZE;
    tty.c_cflag |= CS8;         /* 8-bit characters */
    tty.c_cflag &= ~PARENB;     /* no parity bit */
    tty.c_cflag &= ~CSTOPB;     /* only need 1 stop bit */
    tty.c_cflag &= ~CRTSCTS;    /* no hardware flowcontrol */

    tty.c_lflag |= ICANON | ISIG;  /* canonical input */
    tty.c_lflag &= ~(ECHO | ECHOE | ECHONL | IEXTEN);

    tty.c_iflag &= ~IGNCR;  /* preserve carriage return */
    tty.c_iflag &= ~INPCK;
    tty.c_iflag &= ~(INLCR | ICRNL | IUCLC | IMAXBEL);
    tty.c_iflag &= ~(IXON | IXOFF | IXANY);   /* no SW flowcontrol */

    tty.c_oflag &= ~OPOST;

    tty.c_cc[VEOL] = 0;
    tty.c_cc[VEOL2] = 0;
    tty.c_cc[VEOF] = 0x04;

    if (tcsetattr(fd, TCSANOW, &tty) != 0) {
        printf("Error from tcsetattr: %s\n", strerror(errno));
        return false;
    }
    return true;
}


bool update(){
	/*
	string line;
	while(line.size() == 0 ){
		char buf[readBufferSize];
		int result = read(fd, &buf, readBufferSize);
		if(result <= 0){
			cerr << "tmclient: failed to read from port with error " << result << endl;
			continue;
		}
		readBuffer += string(buf);
		for(int i = 0; i < readBuffer.size(); i++){
			if(readBuffer[i] == '\n'){
				line = readBuffer.substr(0, i+1);
				readBuffer = readBuffer.substr(i+1, readBuffer.size()-i+1);
				break;
			}
		}
		this_thread::sleep_for(100ms); // TODO this value is guessed to avoid high CPU?
	}
	*/


	// Does this read 1 line?
    char buf[83];
    int rdlen = read(fd, buf, sizeof(buf) - 1);
    if (rdlen > 0) {
        buf[rdlen] = 0;
    } else if (rdlen < 0) {
        printf("Error from read: %d: %s\n", rdlen, strerror(errno));
    } else {
        printf("Nothing read. EOF?\n");
    }
    string line(buf);
    cout << line << endl;
	vector<string> sensorElements = util::strSplit(line, "\t");
	for(string sensorDataString: sensorElements){
		vector<string> sensorDataElements = util::strSplit(sensorDataString, ":");
		if(sensorDataElements.size() != 2){
			cerr << "tmclient: unable to parse sensorDataString, sensorDataElements size is not 2 but " << sensorDataElements.size() << endl;
			return false;
		}
		try{
			temperatures[stoul(sensorDataElements[0])] = stof(sensorDataElements[1]);
		}catch(const exception& e){
			cerr << "tmclient: unable to parse sensorDataString, numerical interpretation failed for " << sensorDataElements[0] << " or " << sensorDataElements[1] << " with exception " << e.what() << endl;
			return false;
		}
	}
	return true;
}



}

/*

 */


