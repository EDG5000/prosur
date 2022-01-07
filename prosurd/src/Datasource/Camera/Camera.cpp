#include <Datasource/Camera/Camera.hpp>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdarg.h>
#include <string.h>
#include <signal.h>
#include <gphoto2/gphoto2.h>
#include <unistd.h>

#include <string>
#include <vector>
#include <iostream>

#include "Database/Frame.hpp"

using namespace std;

namespace Prosur::Datasource::Camera{

	bool ready = false;

	static string errorString(int result){
		return gp_port_result_as_string(result);
	}

	static void init(){
		int retval = gp_log_add_func(GP_LOG_VERBOSE, [](GPLogLevel level, const char *domain, const char *str, void *data) -> void {
			cerr << "Camera: error code: " << to_string(level) << " Message: " << domain << " " << str << endl;
		}, NULL);
		if(retval < GP_OK) {
			cerr << "Camera: gp_log_add_func failed with error: " << errorString(retval) << endl;
			terminate();
		}
	}

	void fillFrame(Database::Frame& frame){
		if(!ready){
			init();
		}

		GPContext* context = gp_context_new();

		::Camera* camera;
		int retval = gp_camera_new(&camera);
		if(retval < GP_OK) {
			cerr << "Camera: gp_camera_new failed with error: " << errorString(retval) << endl;
			gp_camera_unref(camera);
			return;
		}

		retval = gp_camera_init(camera, context);
		if(retval < GP_OK) {
			cerr << "Camera: gp_camera_init failed with error: " << errorString(retval) << endl;
			gp_camera_exit(camera, context);
			return;
		}

		// Capture image, obtain remote path
		CameraFilePath remotePath;
		retval = gp_camera_capture(camera, GP_CAPTURE_IMAGE, &remotePath, context);
		if(retval < GP_OK){
			cerr << "Camera: gp_camera_capture failed with error: " << errorString(retval) << endl;
			gp_camera_exit(camera, context);
			return;
		}

		// Download captured image
		CameraFile* cameraFile;
		retval = gp_file_new(&cameraFile);
		if(retval < GP_OK){
			cerr << "Camera: gp_file_new failed error: " << errorString(retval) << endl;
			gp_file_unref(cameraFile);
			gp_camera_exit(camera, context);
			return;
		}

		retval = gp_camera_file_get(camera, remotePath.folder, remotePath.name, GP_FILE_TYPE_NORMAL, cameraFile, context);
		if(retval < GP_OK){
			cerr << "Camera: gp_camera_file_get failed with error: " << errorString(retval) << endl;
			gp_file_unref(cameraFile);
			gp_camera_exit(camera, context);
			return;
		}

		// Obtain pointer to downloaded image data
		const char* data;
		unsigned long int size;
		retval = gp_file_get_data_and_size(cameraFile, &data, &size);
		if(retval < GP_OK){
			cerr << "Camera: gp_file_get_data_and_size failed with error: " << errorString(retval) << endl;
			gp_file_unref(cameraFile);
			gp_camera_exit(camera, context);
		}

		// Copy downloaded data to our vector and let gphoto release their file
		frame.still.clear();
		frame.still.push_back({});
		frame.still[0].resize(size);
		memcpy(frame.still[0].data(), data, size);
		gp_file_free(cameraFile);

		// Delete remote image
		retval = gp_camera_file_delete(camera, remotePath.folder, remotePath.name, context);

		gp_camera_exit(camera, context);
	}
}
