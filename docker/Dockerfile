FROM ubuntu

RUN apt-get update && apt-get install net-tools iptables iputils-ping iproute2 wget netcat nginx ssh vim -y

COPY init-container /init-container
RUN chmod u+x /init-container/*.sh
