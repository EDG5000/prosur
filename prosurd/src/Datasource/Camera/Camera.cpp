#include <Datasource/Camera/Camera.hpp>

#include <fcntl.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <errno.h>
#include <string.h>

#include <string>
#include <vector>
#include <iostream>
#include <ostream>

#include "linux/v4l2-common.h"
#include "linux/videodev2.h"

#include "Database/Frame.hpp"

using namespace std;

namespace Prosur::Datasource::Camera{

	const string CAMERA_PATH = "/dev/v4l/by-id/usb-046d_0825_533B82A0-video-index0";

	void fillFrame(Database::Frame& frame){

		// 1. Open the device
		// Get file descriptor to the video device
		int fd = open(CAMERA_PATH.c_str(), O_RDWR | O_EXCL);
		if(fd < 0){
			cerr << "Camera: Failed to open device << " << CAMERA_PATH << ", OPEN Errno:" << strerror(errno) << endl;
			terminate();
		}

		// 2. Ask the device if it can capture frames
		v4l2_capability capability;
		if(ioctl(fd, VIDIOC_QUERYCAP, &capability) < 0){
			cerr << "Camera: Failed to get device capabilities, VIDIOC_QUERYCAP Errno: " << strerror(errno) << endl;
			terminate();
		}

		// 3. Set Image format
		v4l2_format imageFormat;
		imageFormat.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
		imageFormat.fmt.pix.width = 1280;
		imageFormat.fmt.pix.height = 960;
		imageFormat.fmt.pix.pixelformat = V4L2_PIX_FMT_MJPEG;
		imageFormat.fmt.pix.field = V4L2_FIELD_NONE;
		// Tell the device you are using this format
		if(ioctl(fd, VIDIOC_S_FMT, &imageFormat) < 0){
			cerr << "Camera: Device could not set format, VIDIOC_S_FMT Errno: " << strerror(errno) << endl;
			terminate();
		}

		// 4. Request Buffers from the device
		v4l2_requestbuffers requestBuffer = {0};
		// One request buffer
		requestBuffer.count = 1;
		// Request a buffer wich we an use for capturing frames
		requestBuffer.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
		requestBuffer.memory = V4L2_MEMORY_MMAP;

		if(ioctl(fd, VIDIOC_REQBUFS, &requestBuffer) < 0){
			cerr << "Camera: Could not request buffer from device, VIDIOC_REQBUFS Errno: " << strerror(errno) << endl;
			terminate();
		}

		// 5. Query the buffer to get raw data ie. ask for the requested buffer and allocate memory for it
		v4l2_buffer queryBuffer = {0};
		queryBuffer.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
		queryBuffer.memory = V4L2_MEMORY_MMAP;
		queryBuffer.index = 0;
		if(ioctl(fd, VIDIOC_QUERYBUF, &queryBuffer) < 0){
			cerr << "Camera: Device did not return the buffer information, VIDIOC_QUERYBUF Errno: " << strerror(errno) << endl;
			terminate();
		}

		// Use a pointer to point to the newly created buffer
		// mmap() will map the memory address of the device to
		// an address in memory
		char* buffer = (char*) mmap(NULL, queryBuffer.length, PROT_READ | PROT_WRITE, MAP_SHARED, fd, queryBuffer.m.offset);
		memset(buffer, 0, queryBuffer.length);

		// 6. Get a frame
		// Create a new buffer type so the device knows which buffer we are talking about
		v4l2_buffer bufferinfo;
		memset(&bufferinfo, 0, sizeof(bufferinfo));
		bufferinfo.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
		bufferinfo.memory = V4L2_MEMORY_MMAP;
		bufferinfo.index = 0;

		// Activate streaming
		int type = bufferinfo.type;
		if(ioctl(fd, VIDIOC_STREAMON, &type) < 0){
			cerr << "Camera: Could not start streaming, VIDIOC_STREAMON Errno: " << strerror(errno) << endl;
			terminate();
		}

		// Queue the buffer
		if(ioctl(fd, VIDIOC_QBUF, &bufferinfo) < 0){
			cerr << "Camera: Could not queue buffer, VIDIOC_QBUF Errno: " << strerror(errno) << endl;
			terminate();
		}

		// Dequeue the buffer
		if(ioctl(fd, VIDIOC_DQBUF, &bufferinfo) < 0){
			cerr << "Camera: Could not dequeue the buffer, VIDIOC_DQBUF Errno: " << strerror(errno) << endl;
			terminate();
		}

		// End streaming
		if(ioctl(fd, VIDIOC_STREAMOFF, &type) < 0){
			cerr << "Camera: Could not end streaming, VIDIOC_STREAMOFF Errno: " << strerror(errno) << endl;
			terminate();
		}

		// Copy data to Frame
		frame.still.push_back({});
		frame.still[0].resize(bufferinfo.bytesused);
		memcpy(frame.still[0].data(), buffer, bufferinfo.bytesused);

		// Unmap the memory. Otherwise, the close() call will be ignored.
		munmap(buffer, queryBuffer.length);

		// Close the video device
		if(close(fd) < 0){
			cerr << "Camera: Camera: Unable to close device " << to_string(fd) << ". Error:  " << strerror(errno) << endl;
		}
	}
}
