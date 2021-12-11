//
//  main.cpp
//  test
//
//  Created by Joel on 8/Dec/2021.
//
#include "json.hpp"

#include <iostream>

using namespace nlohmann;

int main(int argc, const char * argv[]) {
    // insert code here...
    std::cout << "Hello, World!\n";
    return 0;
}

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


using namespace std;

namespace tmclient{

const string DEVICE_NAME = "/dev/ttyUSB0";

vector<int> temperatures; // Hundreds of degrees celcius
string readBuffer;
int fd;

// TODO move to util class
std::vector<std::string> strSplit(std::string str, std::string delim){
    std::vector<std::string> segments;
    std::string::size_type beg = 0;
    for (std::size_t end = 0; (end = str.find(delim, end)) != std::string::npos; ++end)
    {
        segments.push_back(str.substr(beg, end - beg));
        beg = end + 1;
    }
    segments.push_back(str.substr(beg));
    return segments;
}

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
    //tty.c_iflag &= ~(INLCR | ICRNL | IUCLC | IMAXBEL);
    tty.c_iflag &= ~(IXON | IXOFF | IXANY);   /* no SW flowcontrol */

    tty.c_oflag &= ~OPOST;

    tty.c_cc[VEOL] = 0;
    tty.c_cc[VEOL2] = 0;
    tty.c_cc[VEOF] = 0x04;

    if (tcsetattr(fd, TCSANOW, &tty) != 0) {
        cout << "Error from tcsetattr: " << strerror(errno) << endl;
        return false;
    }
    return true;
}

bool update(){
    fd = open("/Users/joel/Downloads", O_RDONLY);

    char buf[128]; // This limits handling of incoming bytes to 128b/s. Ensure remote transmits slower than this. Otherwise, buffer overrun will occur.
    long rdlen = read(fd, buf, sizeof(buf) - 1);
    if (rdlen > 0) {
        // Terminate string
        buf[rdlen] = 0;
    } else if (rdlen < 0) {
        cout << "Error from read: " << " " << strerror(errno) << endl;
    } else {
        cout << "Nothing read. EOF?" << endl;
    }
    readBuffer += string(buf);
    cout << readBuffer << endl;

    vector<string> lines = strSplit(readBuffer, "\n");

    if(lines.size() < 2){
        // No newlines found yet (only happens when line is longer than the buffer; unlikely). Keep reading.
        return false;
    }

    // Normally, 2 lines are in the buffer. The second line is not terminated yet, and is not yet parsed.
    // Parse all segments except the last segment
    for(int lineIndex = 0; lineIndex < lines.size()-1; lineIndex++){
        try{
            json frame(lines[lineIndex]);
            if(frame.size() < 2){
                cout << "Error: expected at least 2 elements in frame: " << lines[lineIndex] << endl;
                return false;
            }
            // Read first element which should equal the element count
            int expectedValues = frame[0];
            if(frame.size()-1 != expectedValues){
                cout << "Error: indicated element count does not correspond to actual element count in frame: " << lines[lineIndex] << endl;
                return false;
            }
            // Ensure the vector is large enough
            if(temperatures.size() < frame.size()-1){
                temperatures.resize(frame.size()-1);
            }
            // Copy values over; start at second element to skip the size-indicating element.
            for(int valueIndex = 1; valueIndex < frame.size(); valueIndex++){
                temperatures[valueIndex-1] = frame[valueIndex];
            }
        }catch(exception e){
            cout << "Error: unable to parse frame: " << lines[lineIndex] << endl;
            return false;
        }
    }

    // Set the buffer to the last line, which was not processed yet
    readBuffer = lines[lines.size()-1];

    return true;
}


/*

 */
}
