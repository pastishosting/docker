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
docker-compose -f $COMPOSE_FILE exec plesk bash -xc 'echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC+GfisIGwH01yz4iaSR4rs4c4LbqQuyGcKJNFSEo9wI/o3IdXsRpk4zmEXrpSBgWi1JzgNddSFEhZ3gffitrSDEN+XDW2MRxgUyMHgRI+0R5hHt6QGKFJSa5QAcPqG3fCG/NhFLD5Kk/++y/Kl+4XP9jX23jvgugCNsIJmpgk2xgIb4imFHe6vyt35NmS/PY7MMwa2TBLOrCe35N5h6AouWnESoyANXotUXL7ktgPVefzR+e2hX1IDHHp4Ge2+Pxfj+VijG8W7AEzzpMHlzYHR1P5s4CnXW3wGjvzXQRphIzl3hyWJYreP/zEMDOqt2qehibwWHWXL2ZXfUixCMngt johan" >> /root/.ssh/authorized_keys'

# Install New Relic
docker-compose -f $COMPOSE_FILE exec 'wget -O - https://download.newrelic.com/548C16BF.gpg | apt-key add -'
docker-compose -f $COMPOSE_FILE exec 'echo "deb http://apt.newrelic.com/debian/ newrelic non-free" > /etc/apt/sources.list.d/newrelic.list'
docker-compose -f $COMPOSE_FILE exec apt-get update
docker-compose -f $COMPOSE_FILE exec apt-get install newrelic-php5
docker-compose -f $COMPOSE_FILE exec newrelic-install install

# Reload Traefik
docker-compose -f $SCRIPT_DIR/../../../services/traefik/docker-compose-$(hostname).yml up --build -d
