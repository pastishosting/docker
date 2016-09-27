#!/bin/bash
source $PWD/lib.sh

EVENT=$1
COMPOSE_FILE=$2

if [ $EVENT == "up" ]; then
    docker-compose -f $COMPOSE_FILE up --force-recreate -d
fi
