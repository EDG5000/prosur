#!/bin/bash

# Copy tree to remote, compile at remote, restart process at remote. (assumes configuration step already manually performed prior). 

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
.. \
$REMOTE_CONN:$REMOTE_PATH

# Compile, kill, run

ssh $REMOTE_CONN "cd $REMOTE_PATH/../build && make && cd $REMOTE_PATH/prosurd && killall prosurd ; ../../build/prosurd &"
