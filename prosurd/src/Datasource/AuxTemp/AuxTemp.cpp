#include <Datasource/AuxTemp/AuxTemp.hpp>

#include <fcntl.h>
#include <stdio.h>
#include <unistd.h>
#include <stdint.h>
#include <termios.h>
#include <errno.h>
#include <stdlib.h>
#include <Util/Util.hpp>
#include <string>
#include <iostream>
#include <vector>

#include "json.hpp"

#include "Database/Frame.hpp"

using namespace nlohmann;
using namespace std;

namespace Prosur::Datasource::AuxTemp{

	const string DEVICE_NAME = "/dev/ttyUSB0";
	string readBuffer;
	int fd;
	bool ready = false;

	static void init(){
		fd = open(DEVICE_NAME.c_str(), O_RDWR | O_NOCTTY | O_SYNC);
		if (fd < 0) {
			cerr << "Error opening " << DEVICE_NAME << " " << strerror(errno) << endl;
			terminate();
		}

		struct termios tty;

		if (tcgetattr(fd, &tty) < 0) {
			cerr << "Error from tcgetattr: " << strerror(errno) << endl;
			terminate();
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

		if(tcsetattr(fd, TCSANOW, &tty) != 0){
			cout << "AuxTemp: Error from tcsetattr: " << strerror(errno) << endl;
			terminate();
		}
	}

	void fillFrame(Database::Frame& frame){
		// TODO for increased reliability, considered reopening the device on each frame
		// TODO however, what to do in case of failures? Right now, the system terminates.
		if(!ready){
			init();
			ready = true;
		}

		frame.auxTemp.clear();

		char buf[128]; // This limits handling of incoming bytes to 128b/s. Ensure remote transmits slower than this. Otherwise, buffer overrun will occur.
		long rdlen = read(fd, buf, sizeof(buf) - 1);
		if (rdlen > 0){
			// Terminate string
			buf[rdlen] = 0;
		}else if (rdlen < 0){
			cout << "Error from read: " << " " << strerror(errno) << endl;
		} else{
			cout << "Nothing read. EOF?" << endl;
		}
		readBuffer += string(buf);

		vector<string> lines = Util::strSplit(readBuffer, "\n");

		if(lines.size() < 2){
			// No newlines found yet (only happens when line is longer than the buffer; unlikely). Keep reading.
			return;
		}

		// Normally, 2 lines are in the buffer. The second line is not terminated yet, and is not yet parsed.
		// Parse all segments except the last segment
		for(int lineIndex = 0; lineIndex < lines.size()-1; lineIndex++){
			try{
				json auxTempFrame = json::parse(lines[lineIndex]);
				if(auxTempFrame.size() < 2){
					cerr << "Error: expected at least 2 elements in frame: " << lines[lineIndex] << endl;
					terminate();
				}
				// Read first element which should equal the element count
				int expectedValues = auxTempFrame[0];
				if(auxTempFrame.size()-1 != expectedValues){
					cerr << "Error: indicated element count does not correspond to actual element count in frame: " << lines[lineIndex] << endl;
					terminate();
				}
				// Copy values over; start at second element to skip the size-indicating element.
				for(int valueIndex = 1; valueIndex < auxTempFrame.size(); valueIndex++){
					frame.auxTemp.push_back(auxTempFrame[valueIndex]);
				}
			}catch(exception& e){
				cerr << "Warning: Dropping frame: " << lines[lineIndex] << endl;
			}
		}

		// Set the buffer to the last line, which was not processed yet
		readBuffer = lines[lines.size()-1];
	}

}
