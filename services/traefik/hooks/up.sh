#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"
source "$SCRIPT_DIR/../../../bin/lib.sh"

COMPOSE_FILE=$1

# Ugly workaround
docker-compose -f "$COMPOSE_FILE" up --build -d
