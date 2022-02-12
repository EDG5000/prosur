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
#include <thread>

#include "linux/v4l2-common.h"
#include "linux/videodev2.h"

#include "Database/Frame.hpp"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <errno.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/time.h>
#include <sys/mman.h>
#include <linux/videodev2.h>
#include "libv4l2.h"

#include <mutex>
#include <thread>

using namespace std;



namespace Prosur::Datasource::Camera{

	mutex mtx;

	bool ready = false;

	//void* image_buffer = 0; // 0 when empty (while still grabbing first framr)
	//size_t image_buffer_size; // Image buffer

	vector<char> image_buffer;

	#define CLEAR(x) memset(&(x), 0, sizeof(x))

	struct buffer{
		void   *start;
		size_t length;
	};

	static void xioctl(int fh, int request, void *arg){
		int r;

		do{
			r = v4l2_ioctl(fh, request, arg);
		}while (r == -1 && ((errno == EINTR) || (errno == EAGAIN)));

		if(r == -1){
			cerr << "Camera: error: " << strerror(errno) << endl;
			terminate();
		}
	}

	void fillFrame(Database::Frame& frame){

        if(!ready){
        	ready = true;
			thread([]{
				struct v4l2_format              fmt;
				struct v4l2_buffer              buf;
				struct v4l2_requestbuffers      req;
				enum v4l2_buf_type              type;
				fd_set                          fds;
				struct timeval                  tv;
				int                             r, fd = -1;
				unsigned int                    i, n_buffers;
				const char                      *dev_name = "/dev/v4l/by-id/usb-046d_0825_533B82A0-video-index0";
				char                            out_name[256];
				FILE                            *fout;
				struct buffer                   *buffers;

				fd = v4l2_open(dev_name, O_RDWR | O_NONBLOCK, 0);
				if (fd < 0) {
					cerr << "Cannot open device. Error: " << strerror(errno) << endl;
					terminate();
				}

				CLEAR(fmt);
				fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
				fmt.fmt.pix.width = 1280;
				fmt.fmt.pix.height = 960;
				fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_MJPEG;
				fmt.fmt.pix.field = V4L2_FIELD_NONE;
				xioctl(fd, VIDIOC_S_FMT, &fmt);
				if (fmt.fmt.pix.pixelformat != V4L2_PIX_FMT_MJPEG) {
					cerr << "Camera: Libv4l didn't accept V4L2_PIX_FMT_MJPEG format. Can't proceed." << endl;
					terminate();
				}
				if ((fmt.fmt.pix.width != 1280) || (fmt.fmt.pix.height != 960)){
					cerr << "Camera: Libv4l didn't accept requested resoluation. Can't proceed." << endl;
					terminate();
				}

				CLEAR(req);
				req.count = 2;
				req.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
				req.memory = V4L2_MEMORY_MMAP;
				xioctl(fd, VIDIOC_REQBUFS, &req);

				buffers = (buffer*) calloc(req.count, sizeof(*buffers));
				for (n_buffers = 0; n_buffers < req.count; ++n_buffers) {
					CLEAR(buf);

					buf.type        = V4L2_BUF_TYPE_VIDEO_CAPTURE;
					buf.memory      = V4L2_MEMORY_MMAP;
					buf.index       = n_buffers;

					xioctl(fd, VIDIOC_QUERYBUF, &buf);

					buffers[n_buffers].length = buf.length;
					buffers[n_buffers].start = v4l2_mmap(NULL, buf.length, PROT_READ | PROT_WRITE, MAP_SHARED, fd, buf.m.offset);

					if (MAP_FAILED == buffers[n_buffers].start) {
						cerr << "Camera: map failed." << endl;
						terminate();
					}
				}

				for (i = 0; i < n_buffers; ++i) {
					CLEAR(buf);
					buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
					buf.memory = V4L2_MEMORY_MMAP;
					buf.index = i;
					xioctl(fd, VIDIOC_QBUF, &buf);
				}
				type = V4L2_BUF_TYPE_VIDEO_CAPTURE;

				xioctl(fd, VIDIOC_STREAMON, &type);

				while(true){
					do{
						FD_ZERO(&fds);
						FD_SET(fd, &fds);

						/* Timeout. */
						tv.tv_sec = 2;
						tv.tv_usec = 0;

						//r = select(fd + 1, &fds, NULL, NULL, &tv);
						r = select(fd + 1, &fds, NULL, NULL, NULL);
					}while ((r == -1 && (errno = EINTR)));
					if (r == -1) {
						break;
					}

					CLEAR(buf);
					buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
					buf.memory = V4L2_MEMORY_MMAP;
					xioctl(fd, VIDIOC_DQBUF, &buf);


					mtx.lock();
					image_buffer.resize(buf.bytesused);
					memcpy(image_buffer.data(), buffers[buf.index].start, buf.bytesused);
					mtx.unlock();

					xioctl(fd, VIDIOC_QBUF, &buf);
				}

				type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
				xioctl(fd, VIDIOC_STREAMOFF, &type);
				for (i = 0; i < n_buffers; ++i){
					v4l2_munmap(buffers[i].start, buffers[i].length);
				}

				v4l2_close(fd);

				cerr << "Camera: Error in select:" << strerror(errno) << endl;
				terminate();

			}).detach();
        }

		// Copy data to Frame
        if(image_buffer.size() != 0){
        	mtx.lock();
        	frame.still.push_back(image_buffer);
			mtx.unlock();
        }

	}
}
