#!/bin/bash

#cd /home/user/prosur/prosurd/build
cd /home/joel/repos/infinus/prosur/prosurd/build
make
killall prosurd
cd ..
build/prosurd
