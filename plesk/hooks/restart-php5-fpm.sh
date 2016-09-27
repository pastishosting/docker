#!/bin/sh
docker-compose -f $1 exec plesk service php5-fpm restart
