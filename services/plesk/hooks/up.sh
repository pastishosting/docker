#!/bin/sh

# Some services need to be manually (re)started

COMPOSE_FILE=$1

# Apply latest Plesk patches
/opt/psa/admin/sbin/autoinstaller --select-product-id plesk --select-release-current --reinstall-patch --install-component panel

# Fix running services
docker-compose -f $COMPOSE_FILE exec plesk service php5-fpm restart
docker-compose -f $COMPOSE_FILE exec plesk service ssh start
docker-compose -f $COMPOSE_FILE exec plesk service sw-cp-engine restart
