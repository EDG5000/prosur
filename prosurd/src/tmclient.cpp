#include "tmclient.hpp"

#include <fcntl.h>
#include <stdio.h>
#include <unistd.h>
#include <stdint.h>
#include <termios.h>
 
#include <string>
#include <iostream>
#include <map>
#include <vector>

#include "util.hpp"

using namespace std;

namespace tmclient{

const string DEVICE = "/dev/ttyACM0";
int fd = INT32_MAX;
const int readBufferSize = 100;
map<long unsigned int, float> temperatures;


// Opens the specified serial port, sets it up for binary communication,
// configures its read timeouts, and sets its baud rate.
// Returns a non-negative file descriptor on success, or -1 on failure.
bool open_serial_port(){
  fd = open(DEVICE.c_str(), O_RDWR | O_NOCTTY);
  if(fd < 0){
      cerr << "tmclient: open_serial_port: opening port failed with fd " << fd << endl;
    return true;
  }
 
  // Flush away any bytes previously read or written.
  int result = tcflush(fd, TCIOFLUSH);
  if(result){
      cerr << "tmclient: tcflush failed" << endl;
  }
 
  // Get the current configuration of the serial port.
  struct termios options;
  result = tcgetattr(fd, &options);
  if(result){
      cerr << "tmclient: tcgetattr failed" << endl;
      
    close(fd);
    return true;
  }
 
  // Turn off any options that might interfere with our ability to send and
  // receive raw binary bytes.
  options.c_iflag &= ~(INLCR | IGNCR | ICRNL | IXON | IXOFF);
  options.c_oflag &= ~(ONLCR | OCRNL);
  options.c_lflag &= ~(ECHO | ECHONL | ICANON | ISIG | IEXTEN);
 
  // Set up timeouts: Calls to read() will return as soon as there is
  // at least one byte available or when 100 ms has passed.
  options.c_cc[VTIME] = 1;
  options.c_cc[VMIN] = 0;
 
  cfsetospeed(&options, B115200);
  cfsetispeed(&options, cfgetospeed(&options));
 
  result = tcsetattr(fd, TCSANOW, &options);
  if(result){
    cerr << "tmclient: tcsetattr failed" << endl;
    close(fd);
    return false;
  }
  return true;
}
 
// Writes bytes to the serial port, returning 0 on success and -1 on failure.
/*
int write(int fd, uint8_t * buffer, size_t size){
  ssize_t result = write(fd, buffer, size);
  if (result != (ssize_t)size){
    cout << "tmclient: failed to write to port";
    return -1;
  }
  return 0;
}
*/
 
string readBuffer;

// Reads bytes from the serial port.
// Returns after all the desired bytes have been read, or if there is a
// timeout or other error.
// Returns the number of bytes successfully read into the buffer, or -1 if
// there was an error reading.
string read_line(){
	while(true){
		char buf[readBufferSize];
		ssize_t r = read(fd, &buf, readBufferSize);
		if(r < 0){
			cerr << "tmclient: failed to read from port";
			return "";
		}
		if(r == 0){
			// Timeout
			continue;
		}
		readBuffer += string(buf);
		for(int i = 0; i < readBuffer.size(); i++){
			if(readBuffer[i] == '\n'){
				string line = readBuffer.substr(0, i+1);
				readBuffer = readBuffer.substr(i+1, readBuffer.size()-i+1);
				return line;
			}
		}
	}
}
 

 /*
void close_port(){
  close(fd);
}
*/
  
/*
 string isodatetime();
 vector<string> strSplit(string str, string delim);
 void replaceAll(string& str, const string& from, const string& to);
 const string urlDecode (const string& str);
 const string urlEncode(const string& s);
 string join(const vector<string>& elems, string delim);
 uint64_t getTimeMillis();
 */

bool init(){
  return open_serial_port();
}

bool update(){
	string line = read_line();
    if(line.size() == 0){
        cerr << "" << endl;
    }
    vector<string> sensorElements = util::strSplit(line, "\t");
    for(string sensorDataString: sensorElements){
        vector<string> sensorDataElements = util::strSplit(sensorDataString, "\t");
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



