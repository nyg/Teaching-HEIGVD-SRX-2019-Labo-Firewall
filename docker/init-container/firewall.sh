#!/usr/bin/env sh

# enable internet access for lan and dmz machines
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

# permit root login with password – avoid in real life
sed -Ei 's/^#(PermitRootLogin).*/\1 yes/' /etc/ssh/sshd_config

# set root password – secure stuff :)
echo root:root | chpasswd

# start services
service nginx start
service ssh start

# start bash to keep container running
/bin/bash
