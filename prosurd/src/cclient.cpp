#include "cclient.hpp"

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

using namespace std;

#include "gphoto2/gphoto2.h"

namespace cclient{

vector<uint8_t> image;

bool update(){
	Camera* camera;
	GPContext* context = gp_context_new();

	/* All the parts below are optional! */
    //gp_context_set_error_func (context, ctx_error_func, NULL);
    //gp_context_set_status_func (context, ctx_status_func, NULL);

	/* also:
	gp_context_set_cancel_func    (p->context, ctx_cancel_func,  p);
        gp_context_set_message_func   (p->context, ctx_message_func, p);
        if (isatty (STDOUT_FILENO))
                gp_context_set_progress_funcs (p->context,
                        ctx_progress_start_func, ctx_progress_update_func,
                        ctx_progress_stop_func, p);
	 */

	/*
	int retval = gp_log_add_func(GP_LOG_ERROR, [](GPLogLevel level, const char *domain, const char *str, void *data) -> void {
		cerr << "cclclient: gphoto2 error: " << domain << " " << str << " " << data << endl;
	}, 0);
	if(retval < GP_OK) {
		cerr << "cclient: unable to add log func, error code: " << retval << endl;
		return false;
	}else{
		cout << "cclient: log function added." << endl;
	}
	*/

	int retval = gp_camera_new(&camera);
	if(retval < GP_OK) {
		cerr << "cclient: unable to create new camera, error code: " << retval << endl;
		return false;
	}else{
		cout << "cclient: camera created." << endl;
	}

	retval = gp_camera_init(camera, context);
	if(retval < GP_OK) {
		cerr << "cclient: unable to init camera, error code: " << retval << endl;
		return false;
	}else{
		cout << "cclient: camera initialized." << endl;
	}

	/* optional: set camera config
	retval = set_config_value_string (camera, buf, s+1, context);
	if (retval < GP_OK)
		fprintf (stderr, "setting configuration '%s' to '%s' failed with %d.\n", buf, s+1, retval);
	else
		fprintf (stderr, "changed configuration '%s' to '%s'\n", buf, s+1);
	*/




	// Capture image, obtain remote path
	CameraFilePath remotePath;
	retval = gp_camera_capture(camera, GP_CAPTURE_IMAGE, &remotePath, context);
	if(retval < GP_OK){
		cerr << "cclient: gphoto2: unable to capture image, return code " << retval << endl;
		return false;
	}else{
		cout << "cclient: gphoto2: gp_camera_capture complete." << endl;
	}

	// Download captured image
	CameraFile* cameraFile;
	retval = gp_file_new(&cameraFile);
	if(retval < GP_OK){
		cerr << "cclient: gphoto2: gp_file_new failed with error code " << retval << endl;
		return false;
	}else{
		cout << "cclient: gphoto2: gp_file_new complete." << endl;
	}

	retval = gp_camera_file_get(camera, remotePath.folder, remotePath.name, GP_FILE_TYPE_NORMAL, cameraFile, context);
	if(retval < GP_OK){
		cerr << "cclient: gphoto2: gp_camera_file_get failed with error code " << retval << endl;
		gp_file_free(cameraFile);
		return false;
	}

	// Obtain pointer to downloaded image data
	const char* data;
	unsigned long int size;
	retval = gp_file_get_data_and_size(cameraFile, &data, &size);
	if(retval < GP_OK){
		cerr << "cclient: gphoto2: unable to get image data data and size, return code " << retval << endl;
		return false;
	}

	// Copy downloaded data to our vector and let gphoto release their file
	image.resize(size);
	memcpy(image.data(), data, size);
	gp_file_free(cameraFile);

	// Delete remote image
	retval = gp_camera_file_delete(camera, remotePath.folder, remotePath.name, context);

	gp_camera_exit(camera, context);

	return true;
}


/*
void deinit(){
	gp_camera_exit(camera, context);
}
*/

}
