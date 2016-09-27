#!/bin/bash
export PATH=/opt/opscode/bin:/opt/opscode/bin/embedded:$PATH
/opt/opscode/embedded/bin/runsvdir-start &
chef-server-ctl start
# Output current state of things for sanity's sake
chef-server-ctl status
# Something useful that also keeps the container running...
tail -f /var/log/opscode/nginx/access.log
