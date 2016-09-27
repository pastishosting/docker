#!/bin/bash
source $PWD/lib.sh

EVENT=$1
COMPOSE_FILE=$2

if [ $EVENT == "up" ]; then
    # Ugly workaround
    docker-compose -f $COMPOSE_FILE stop
    docker-compose -f $COMPOSE_FILE rm -f
    docker-compose -f $COMPOSE_FILE start
fi
