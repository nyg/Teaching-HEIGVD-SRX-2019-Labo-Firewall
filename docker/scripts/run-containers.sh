#!/usr/bin/env sh

# run firewall
docker run -di --rm -e "TERM=xterm-color" --cap-add=NET_ADMIN --cap-add=NET_RAW --name firewall -h Firewall srx/firewall-lab /init-container/firewall.sh

# connect firewall to dmz and lan networks
docker network connect lan firewall
docker network connect dmz firewall

# run dmz and lan containers
docker run -di --rm -e "TERM=xterm-color" --net dmz --cap-add=NET_ADMIN --cap-add=NET_RAW --name dmz -h ServerInDMZ srx/firewall-lab /init-container/dmz.sh
docker run -di --rm -e "TERM=xterm-color" --net lan --cap-add=NET_ADMIN --cap-add=NET_RAW --name lan -h ClientInLAN srx/firewall-lab /init-container/lan.sh
