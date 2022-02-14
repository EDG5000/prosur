#include <Datasource/Camera/Camera.hpp>

#include <fcntl.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <errno.h>
#include <string.h>
#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <linux/videodev2.h>

#include <string>
#include <vector>
#include <iostream>
#include <ostream>
#include <mutex>
#include <thread>

#include "linux/v4l2-common.h"
#include "linux/videodev2.h"
#include "libv4l2.h"

#include "Database/Frame.hpp"
#include "Main.hpp"
#include "Main.hpp"

using namespace std;

namespace Prosur::Datasource::Camera{

	mutex mtx;
	bool ready = false;
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
			log("Camera: error: " + string(strerror(errno)));
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
					log("Cannot open device. Error: " + string(strerror(errno)));
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
					log("Camera: Libv4l didn't accept V4L2_PIX_FMT_MJPEG format. Can't proceed.");
					terminate();
				}
				if ((fmt.fmt.pix.width != 1280) || (fmt.fmt.pix.height != 960)){
					log("Camera: Libv4l didn't accept requested resoluation. Can't proceed.");
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
						log("Camera: map failed.");
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
					// Get frame collection start time
					struct timeval tv;
					gettimeofday(&tv,NULL);
					long startTime = tv.tv_sec*(uint64_t)1000000+tv.tv_usec;

					do{
						FD_ZERO(&fds);
						FD_SET(fd, &fds);

						/* Timeout. */
						tv.tv_sec = 2;
						tv.tv_usec = 0;

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

					// Get frame collection end time
					gettimeofday(&tv,NULL);
					long endTime = tv.tv_sec*(uint64_t)1000000+tv.tv_usec;

					// Sleep to maintain needed collection frequency
					int64_t timeTaken = endTime - startTime;
					int64_t sleepTime = (FRAME_COLLECTION_INTERVAL * STILL_CAPTURE_INTERVAL) - timeTaken;
					if(sleepTime < 0){
						log("Camera: warning: taking " + to_string(sleepTime * -1) + "us too long to keep up with desired " + to_string(FRAME_COLLECTION_INTERVAL) + "us image collection rate.");
						sleepTime = 0;
					}
					usleep(sleepTime);
				}

				type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
				xioctl(fd, VIDIOC_STREAMOFF, &type);
				for (i = 0; i < n_buffers; ++i){
					v4l2_munmap(buffers[i].start, buffers[i].length);
				}

				v4l2_close(fd);

				log("Camera: Error in select:" + string(strerror(errno)));
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
