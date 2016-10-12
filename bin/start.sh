#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"
ROOT_DIR=$SCRIPT_DIR/..
source $SCRIPT_DIR/lib.sh

# Fail early
set -e

HOST=${1:-$(hostname)}

log "Starting services - hostname=${HOST}"
for service in $ROOT_DIR/services/*; do
    serviceName=$(basename $service)
    if [ -d $service ]; then
        if [ -f $service/.servers ] && grep -q ${HOST} $service/.servers; then
            log "service is enabled on host - hostname=${HOST}, service=${serviceName}"
            log "Executing docker-compose up - hostname=${HOST}, service=${serviceName}"
            if [ -f $service/docker-compose-${HOST}.yml ]; then
                docker-compose -f $service/docker-compose-${HOST}.yml up -d
                if [ -d $service/hooks ]; then
                    for hook in $(find $service/hooks -name '*' -type f); do
                        log "Executing hook - hostname=${HOST}, service=${serviceName}, hook=$(basename $hook)"
                        ( exec $hook up $service/docker-compose-${HOST}.yml )
                    done
                fi
            elif [ -f $service/docker-compose.yml ]; then
                docker-compose -f $service/docker-compose.yml up -d
                if [ -d $service/hooks ]; then
                    log "Executing hooks - hostname=${HOST}, service=${serviceName}"
                    for hook in $(find $service/hooks -name '*' -type f); do
                        log "Executing hook - hostname=${HOST}, service=${serviceName}, hook=$(basename $hook)"
                        ( exec $hook up $service/docker-compose.yml )
                    done
                fi
            fi
        fi
    fi
done
