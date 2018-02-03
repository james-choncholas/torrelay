#!/bin/sh

exec docker run -it\
    --rm \
    torrelay

    #--shm-size 2g \
    #--entrypoint "/bin/bash" \
    #--hostname `hostname` \
    #--volume $PWD/Downloads:/tor-browser/Browser/Downloads \
    #--publish 9153 \
