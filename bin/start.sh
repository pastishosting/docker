#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"
ROOT_DIR=$SCRIPT_DIR/..
source $SCRIPT_DIR/lib.sh

# Fail early
set -e

HOST=${1:-$(hostname)}
HOSTSUFFIX=""

log "Starting services - hostname=${HOST}"
for service in $ROOT_DIR/services/*; do
    serviceName=$(basename $service)
    if [ -d $service ]; then
        if [ -f $service/.servers ] && grep -q ${HOST} $service/.servers; then
            # Guess docker-compose.yml file path
            if [ -f $service/docker-compose-${HOST}.yml ]; then
                HOSTSUFFIX="-${HOST}"
            fi

            # Execute hooks
            log "service is enabled on host - hostname=${HOST}, service=${serviceName}"
            log "Executing docker-compose up - hostname=${HOST}, service=${serviceName}"
            docker-compose -f $service/docker-compose${HOSTSUFFIX}.yml up -d
            if [ -f $service/hooks/up.sh ]; then
                log "Executing hook - hostname=${HOST}, service=${serviceName}, hook=up.sh"
                ( exec $service/hooks/up.sh $service/docker-compose${HOSTSUFFIX}.yml )
            fi
        fi
    fi
done
