#!/bin/bash

# Load config
source run-remote.config

# Tail the log file
ssh $REMOTE_CONN "tail -f prosurd.log"