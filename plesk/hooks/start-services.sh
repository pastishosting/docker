#!/bin/sh

# Some services need to be manually (re)started

EVENT=$1
COMPOSE_FILE=$2

if [ $EVENT == "up" ]; then
    docker-compose -f $COMPOSE_FILE exec plesk service php5-fpm restart
    docker-compose -f $COMPOSE_FILE exec plesk service ssh start
    docker-compose -f $COMPOSE_FILE exec plesk service sw-cp-engine restart
fi
