#!/bin/bash

# Must be run on remote

FILENAME=$(ls /var/lib/coredumps -Art | tail -n 1)

gdb ~/build_prosurd/prosurd /var/lib/coredumps/$FILENAME