#!/bin/sh
EVENT=$1
COMPOSE_FILE=$2

if [ $EVENT == "up" ]; then
    docker-compose -f $COMPOSE_FILE exec plesk service php5-fpm restart
fi
