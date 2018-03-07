#!/bin/sh

exec docker run -it\
    --rm \
    -p 9001:9001 \
    torrelay

    #--shm-size 2g \
    #--entrypoint "/bin/bash" \
    #--hostname `hostname` \
    #--publish 9153 \
