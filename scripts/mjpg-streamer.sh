sleep 10

# Write output to file (both stdout and stderr). Put proces in background.
sudo /usr/local/bin/mjpg_streamer -i "/usr/local/lib/mjpg-streamer/input_uvc.so -d /dev/v4l/by-id/usb-046d_0825_533B82A0-video-index0 -n -f 10 -r 1280x720" -o "/usr/local/lib/mjpg-streamer/output_http.so -p 8080 -w /usr/local/share/mjpg-streamer/www"  >> /mnt/data/mjpg_streamer.log 2>&1 &
