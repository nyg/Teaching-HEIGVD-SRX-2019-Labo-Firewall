#!/usr/bin/env sh

# Règle 8 : par défault, toute action est interdite.
iptables -t filter -P FORWARD DROP
iptables -t filter -P INPUT DROP
iptables -t filter -P OUTPUT DROP

# Règle 2 : autoriser les ping du LAN au WAN, du LAN à la DMZ et de la DMZ au LAN.
iptables -t filter -A FORWARD -p icmp --icmp-type echo-request -s 192.168.100.0/24 -o eth0 -j ACCEPT
iptables -t filter -A FORWARD -p icmp --icmp-type echo-reply   -d 192.168.100.0/24 -i eth0 -j ACCEPT

iptables -t filter -A FORWARD -p icmp --icmp-type echo-request -s 192.168.100.0/24 -d 192.168.200.0/24 -j ACCEPT
iptables -t filter -A FORWARD -p icmp --icmp-type echo-reply   -d 192.168.100.0/24 -s 192.168.200.0/24 -j ACCEPT

iptables -t filter -A FORWARD -p icmp --icmp-type echo-request -s 192.168.200.0/24 -d 192.168.100.0/24 -j ACCEPT
iptables -t filter -A FORWARD -p icmp --icmp-type echo-request -d 192.168.200.0/24 -s 192.168.100.0/24 -j ACCEPT

# Règle 1 : autoriser les requêtes DNS du LAN au WAN (UDP & TCP).
iptables -t filter -A FORWARD -p udp -s 192.168.100.0/24 -o eth0 --dport 53 -j ACCEPT
iptables -t filter -A FORWARD -p udp -d 192.168.100.0/24 -i eth0 --sport 53 -j ACCEPT

iptables -t filter -A FORWARD -p tcp -s 192.168.100.0/24 -o eth0 --dport 53 -j ACCEPT
iptables -t filter -A FORWARD -p tcp -d 192.168.100.0/24 -i eth0 --sport 53 -j ACCEPT

# Règle 3 et 4 : autoriser le traffic du LAN au WAN sur les ports 80, 8080 et 443.
iptables -t filter -A FORWARD -p tcp -s 192.168.100.0/24 -o eth0 --dport 80 -j ACCEPT
iptables -t filter -A FORWARD -p tcp -d 192.168.100.0/24 -i eth0 --sport 80 -j ACCEPT

iptables -t filter -A FORWARD -p tcp -s 192.168.100.0/24 -o eth0 --dport 8080 -j ACCEPT
iptables -t filter -A FORWARD -p tcp -d 192.168.100.0/24 -i eth0 --sport 8080 -j ACCEPT

iptables -t filter -A FORWARD -p tcp -s 192.168.100.0/24 -o eth0 --dport 443 -j ACCEPT
iptables -t filter -A FORWARD -p tcp -d 192.168.100.0/24 -i eth0 --sport 443 -j ACCEPT

# Règle 5 : autoriser le traffic du LAN et WAN vers le server web de la DMZ sur le port 80.
iptables -t filter -A FORWARD -p tcp -s 192.168.100.0/24 -d 192.168.200.3 --dport 80 -j ACCEPT
iptables -t filter -A FORWARD -p tcp -d 192.168.100.0/24 -s 192.168.200.3 --sport 80 -j ACCEPT

iptables -t filter -A FORWARD -p tcp -i eth0 -d 192.168.200.3 --dport 80 -j ACCEPT
iptables -t filter -A FORWARD -p tcp -o eth0 -s 192.168.200.3 --sport 80 -j ACCEPT

# Règle 6 : autoriser les connections ssh du client LAN au server web de la DMZ sur le port 22.
iptables -t filter -A FORWARD -p tcp -s 192.168.100.3 -d 192.168.200.3 --dport 22 -j ACCEPT
iptables -t filter -A FORWARD -p tcp -d 192.168.100.3 -s 192.168.200.3 --sport 22 -j ACCEPT

# Règle 6 : autoriser les connections ssh du client LAN au firewall sur le port 22.
iptables -t filter -A INPUT  -p tcp -s 192.168.100.3 -d 192.168.100.2 --dport 22 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp -d 192.168.100.3 -s 192.168.100.2 --sport 22 -j ACCEPT
