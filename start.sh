# Joel: Ramdisk for HC3D datalogging
sudo mount -t tmpfs -o size=50M,mode=700 tmpfs /mnt/ramdisk
sudo /bin/chown pi:root /mnt/ramdisk
sudo /bin/chmod 0777 /mnt/ramdisk

sudo /usr/bin/java -jar /home/pi/hc3d/main.jar /home/pi/hc3d >> /mnt/ramdisk/output.log &
