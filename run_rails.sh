#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)
cd $SCRIPT_DIR

export PATH=/usr/local/bin:/usr/bin:/bin

while true
do
/usr/local/bin/bundle exec rails s -b 0.0.0.0
done
