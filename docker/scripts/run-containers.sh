#!/usr/bin/env sh

# if first argument is empty, start all servers (f, d, l)
[ -z $1 ] && $1="fdl"

DOCKER_RUN=docker run -di --rm -e "TERM=xterm-color" --cap-add=NET_ADMIN --cap-add=NET_RAW

# start firewall container and connect it to the dmz and lan networks
[[ $1 =~ "f" ]] &&
$DOCKER_RUN --name firewall -h Firewall srx/firewall-lab

# start dmz container and expose port 80 for the webserver
[[ $1 =~ "d" ]] &&
$DOCKER_RUN --net dmz --name dmz -h ServerInDMZ -p 8080:80 srx/firewall-lab

# start lan container
[[ $1 =~ "l" ]] &&
$DOCKER_RUN --net lan --name lan -h ClientInLAN srx/firewall-lab
