#!/bin/bash
export PATH=/opt/opscode/bin:/opt/opscode/bin/embedded:$PATH

# Start this so that chef-server-ctl sv-related commands can
# interact with its services via runsv
/opt/opscode/embedded/bin/runsvdir-start &
apt update
chef-server-ctl install chef-manage
chef-server-ctl reconfigure
opscode-manage-ctl reconfigure --accept-license

# Something useful that also keeps the container running...
tail -f /var/log/opscode/nginx/access.log
