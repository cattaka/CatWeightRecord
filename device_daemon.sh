#!/bin/sh

SCRIPT_DIR=$(cd $(dirname $0); pwd)
cd $SCRIPT_DIR

export PATH=/usr/local/bin:/usr/bin:/bin

while true
do
/usr/bin/python3 device_daemon.py
done
