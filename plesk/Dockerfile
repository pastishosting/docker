FROM plesk/plesk

# Setup packages repositories
RUN echo "deb http://fr.archive.ubuntu.com/ubuntu/ trusty multiverse" > /etc/apt/sources.list.d/multiverse.list \
    && echo "deb http://fr.archive.ubuntu.com/ubuntu/ trusty universe" > /etc/apt/sources.list.d/universe.list

# Install additional packages
RUN apt-get update -y \
    && apt-get upgrade -y \
    && apt-get install -y \
        openssh-server \
        postfix \
        rpl \
        rsync \
        rsyslog \
        tmpreaper \
        vim \
        # Packages required by some legacy projects
        # -- radio.musiqueapproximative.net
        lame \
        libsox-fmt-mp3 \
        mp3gain \
        sox \
        # -- ouiedire.net
        eyeD3 \
    && rm -rf /var/lib/apt/lists/*

# Configure packages
RUN rpl "SHOWWARNING=true" "SHOWWARNING=false" /etc/tmpreaper.conf
RUN locale-gen fr_FR.UTF-8

# Setup SSH
RUN update-rc.d ssh defaults \
    && ssh-keygen -N "" -f /root/.ssh/id_rsa \
    && echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDBtkxRXehGPwJ0KKcyrXq9o2/hfEt06vjcZLakRWHMaJD0WTJrKNNn1Mq+bKf6wJkTW2CWDnjiTMFcqQaTUQfn0bcNhnPgZ6zyYFd/SiC2kZRuvnVYP2kV7MZMvgnEQjrpxCd7mxOmhih1gv68SSk94MmEVXBhjQEVZsFJHyBaNp++NY2+JsjYyuFwPURH+3XcJS3H8QEyVOnnFzJ7ZOo/egk3FoQMmbljgSHMg/jgrIQIAMtFS2PFa0oLUH6+nAZpbS4mNufN7L6T5iwgMAkbrO3Ff/1tQIOu3t/bHKUtwmeUMuKdAz0m2Hu/LImcJBz45u1vsr6ED3qLEEbk9yfx tristan" > /root/.ssh/authorized_keys

# Legacy for mazemod.org
RUN apt-get update \
    # && plesk sbin autoinstaller --select-product-id plesk --select-release-current  --install-component php5.2 \
    && apt-get install php-pear \
    && pear install validate-beta \
    && pear install xml_parser \
    && pear install xml_tree-2.0.0RC2 \
    && rm -rf /var/lib/apt/lists/*

# Upgrade Plesk
# ERROR: The executed process was terminated because of unhandled signal received from the system.
# RUN /opt/psa/admin/sbin/autoinstaller --select-product-id plesk --select-release-current --reinstall-patch --install-component panel
