#!/usr/bin/env sh

# remove default route and create new one to go through firewall only
ip route del default
ip route add default via 192.168.100.2

# start bash to keep container running
/bin/bash
