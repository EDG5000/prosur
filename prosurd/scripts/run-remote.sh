#!/bin/bash

#
# Copy source tree to remote, compile at remote, restart process at remote, start tailing log output. (assumes configuration step already manually performed prior). 
#

# Load config
source run-remote.config

# Transfer
rsync \
--progress \
--recursive \
--links \
--perms \
--times \
--group \
--owner \
--devices \
--specials \
--compress \
--delete \
--executability \
--log-file-format="%t [%p] %o %h [%a] %m (%u) %f %l" \
../.. \
$REMOTE_CONN:$REMOTE_PATH

# Compile, kill, run in background
ssh $REMOTE_CONN "cd $REMOTE_PATH/../build_prosurd && make && cd $REMOTE_PATH/prosurd && killall prosurd ; scripts/run-prosurd.sh >/dev/null 2>/dev/null &"

# Tail the log file
ssh $REMOTE_CONN "cd $REMOTE_PATH && tail -f ../prosurd.log"