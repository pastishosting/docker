#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"
ROOT_DIR=$SCRIPT_DIR/..
source $SCRIPT_DIR/lib.sh

# Fail early
set -e

PULL=${1:-""}
HOST=${2:-$(hostname)}
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

            log "service is enabled on host - hostname=${HOST}, service=${serviceName}"
            log "Executing docker-compose up - hostname=${HOST}, service=${serviceName}"

            # Get latest images
            if [ $PULL == "pull" ]; then
                docker-compose -f $service/docker-compose${HOSTSUFFIX}.yml pull
            fi

            # Recreate and start images if necessary
            docker-compose -f $service/docker-compose${HOSTSUFFIX}.yml up -d

            # Execute hooks
            if [ -f $service/hooks/up.sh ]; then
                log "Executing hook - hostname=${HOST}, service=${serviceName}, hook=up.sh"
                ( exec $service/hooks/up.sh $service/docker-compose${HOSTSUFFIX}.yml )
            fi
        fi
    fi
done
