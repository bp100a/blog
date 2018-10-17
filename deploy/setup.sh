#!/bin/bash
#
# pi-blog setup script.
# ---------------------
# Author: HjC
#
# This script will initialize a raspberry pi to host our blog
#

# get our intranet IP address
export IPADDR=`hostname -I`

# if Nginx not installed, install it now
if ! which nginx > /dev/null 2 >&1; then
	sudo apt-get install -y nginx
fi

sudo service nginx stop
# copy our configuration file
echo "...DONE startup script"
