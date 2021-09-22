#!/bin/sh

tag=ctkdeskmini.home.cattaka.net:32000/cat-weight-record:$(date '+%Y%m%d%H%M%S')
docker build -t $tag .
echo "Execute this to push image: \"docker push $tag\""

