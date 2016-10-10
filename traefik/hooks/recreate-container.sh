#!/bin/bash
source $PWD/lib.sh

EVENT=$1
COMPOSE_FILE=$2

if [ $EVENT == "up" ]; then
    # Ugly workaround
    docker-compose up --build -d
fi
