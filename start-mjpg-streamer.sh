/usr/local/bin/mjpg_streamer -i "/usr/local/lib/mjpg-streamer/input_uvc.so -d /dev/webcam -n -f 10 -r 1280x720" \
-o "/usr/local/lib/mjpg-streamer/output_http.so -p 80 -w /usr/local/share/mjpg-streamer/www" >> /home/pi/mjpeg_streamer.log &
