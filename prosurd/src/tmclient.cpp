#include "tmclient.hpp"

#include <fcntl.h>
#include <stdio.h>
#include <unistd.h>
#include <stdint.h>
#include <termios.h>
 
#include <string>
#include <iostream>

using namespace std;

const string device = "/dev/ttyACM0";
int fd = INT32_MAX;
const int readBufferSize = 100;

namespace tmclient{

// Opens the specified serial port, sets it up for binary communication,
// configures its read timeouts, and sets its baud rate.
// Returns a non-negative file descriptor on success, or -1 on failure.
int open_serial_port(string device){
  int fd = open(device.c_str(), O_RDWR | O_NOCTTY);
  if(fd == -1){
    cout << device;
    return -1;
  }
 
  // Flush away any bytes previously read or written.
  int result = tcflush(fd, TCIOFLUSH);
  if(result){
      cout << "tmclient: tcflush failed" << endl;
  }
 
  // Get the current configuration of the serial port.
  struct termios options;
  result = tcgetattr(fd, &options);
  if(result){
    cout << "tmclient: tcgetattr failed" << endl;
      
    close(fd);
    return -1;
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
    cout << "tmclient: tcsetattr failed";
    close(fd);
    return -1;
  }
 
  return fd;
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
      cout << "tmclient: failed to read from port";
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
 
bool init(){
  fd = open_serial_port(device);
  if(fd < 0){
	return false;
  }
    return true;
}
 
void close_port(){
  close(fd);
}

}

int main(){
    tmclient::init();
}

