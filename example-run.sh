#!/bin/bash

docker run -it \
    --rm \
    --name torrelay \
    -p 9001:9001 \
    -d torrelay
