#!/bin/bash

if [[ -z $DOCKER_IMAGE ]]; then
  DOCKER_IMAGE="quay.io/efuquen/docoreos-express-demo"
fi

docker build -t $DOCKER_IMAGE .
echo "Docker run listening on http://127.0.0.1:48200"
docker run --rm -i -t -p 48200:3000 $DOCKER_IMAGE

