#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"
source $SCRIPT_DIR/../../../bin/lib.sh

# Some services need to be manually (re)started

COMPOSE_FILE=$1

# Apply latest Plesk patches
docker-compose -f $COMPOSE_FILE exec plesk /opt/psa/admin/sbin/autoinstaller --select-product-id plesk --select-release-current --reinstall-patch --install-component panel

# Install Postfix
docker-compose -f $COMPOSE_FILE exec plesk /usr/local/psa/admin/sbin/autoinstaller --select-release-current --install-component postfix

# Fix running services
docker-compose -f $COMPOSE_FILE exec plesk service php5-fpm restart
docker-compose -f $COMPOSE_FILE exec plesk service rsyslog start
docker-compose -f $COMPOSE_FILE exec plesk service ssh start
docker-compose -f $COMPOSE_FILE exec plesk service xinetd restart
docker-compose -f $COMPOSE_FILE exec plesk service sw-cp-server restart

# Deploy SSH keys
docker-compose -f $COMPOSE_FILE exec plesk bash -xc 'if [ ! -d /root/.ssh ]; then ssh-keygen -N "" -f /root/.ssh/id_rsa; fi'
docker-compose -f $COMPOSE_FILE exec plesk bash -xc 'echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDBtkxRXehGPwJ0KKcyrXq9o2/hfEt06vjcZLakRWHMaJD0WTJrKNNn1Mq+bKf6wJkTW2CWDnjiTMFcqQaTUQfn0bcNhnPgZ6zyYFd/SiC2kZRuvnVYP2kV7MZMvgnEQjrpxCd7mxOmhih1gv68SSk94MmEVXBhjQEVZsFJHyBaNp++NY2+JsjYyuFwPURH+3XcJS3H8QEyVOnnFzJ7ZOo/egk3FoQMmbljgSHMg/jgrIQIAMtFS2PFa0oLUH6+nAZpbS4mNufN7L6T5iwgMAkbrO3Ff/1tQIOu3t/bHKUtwmeUMuKdAz0m2Hu/LImcJBz45u1vsr6ED3qLEEbk9yfx tristan" > /root/.ssh/authorized_keys'
docker-compose -f $COMPOSE_FILE exec plesk bash -xc 'echo "ecdsa-sha2-nistp384 AAAAE2VjZHNhLXNoYTItbmlzdHAzODQAAAAIbmlzdHAzODQAAABhBAYK0IYJJFjKv2rjGJHhHotk1rqfZ/xLJQe9Yy2094V0RMwPnSs+GE63yJbsYCxCJgebmsWuj+eWjnisOUALGMEXQOih1luMHMnvEL7cg2nY5IEbyCfN3GhOBDo23YNpMQ== johan" >> /root/.ssh/authorized_keys'

# Reload Traefik
docker-compose -f $SCRIPT_DIR/../../../services/traefik/docker-compose-$(hostname).yml up --build -d
