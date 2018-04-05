#!/bin/bash

print_info() {
  echo -e "\033[33m$1\033[0m"
}

# check if a vpn container using TCP (for tor) exists
if [ ! "$(sudo docker ps -q -f name=torrelay)" ]; then

    # only run as daemon if no extra arguments given
    RUN_AS_DAEMON="-d"
    if [[ $# -ge 1 ]]; then
        RUN_AS_DAEMON=""
    fi

    sudo docker run -it \
        --rm \
        --name torrelay \
        -p 9001:9001 \
        $RUN_AS_DAEMON \
        torrelay $@
else
    echo "torrelay already running"
fi

while true; do
    read -p "Attach to container? [y/n] : " yn
    case $yn in
        [Yy]* )
			print_info "\n\nDetach from container with <C-p> <C-q>"

			secs=$((4))
			while [ $secs -gt 0 ]; do
			   echo -ne "starting in : $secs\033[0K\r"
			   sleep 1
			   : $((secs--))
			done

			sudo docker attach torrelay
			break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
