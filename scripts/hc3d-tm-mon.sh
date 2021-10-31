# Setup serial port
stty -F /dev/ttyUSB0 9600

# Get unix timestamp
TIME_STR=`date +%s`

# Create filename for new session
NEW_LOG_FILENAME="${TIME_STR}.csv"

# Delete old symlink; ignore error
rm /mnt/data/hc3d-tm.log;

# Start logging to new file
cat /dev/ttyUSB0 | ts '%s' >> /mnt/data/"$NEW_LOG_FILENAME" &

# Create symlink to new file
ln -s /mnt/data/"$NEW_LOG_FILENAME" /mnt/data/hc3d-tm.log
