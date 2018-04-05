#!/bin/bash

if [[ $# -ge 1 && -x $(which $1 2>&-) ]]; then
    exec "$@"
elif [[ $# -ge 1 ]]; then
    echo "ERROR: command not found: $1"
    exit 13
else
    echo "Log file at /home/anon/tor.log"
    /usr/bin/tor > /home/anon/tor.log &
    nyx
fi
