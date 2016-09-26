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
        rsyslog \
        tmpreaper \
        vim \
    && rm -rf /var/lib/apt/lists/*

# Configure packages
RUN rpl "SHOWWARNING=true" "SHOWWARNING=false" /etc/tmpreaper.conf
RUN locale-gen fr_FR.UTF-8

# Setup SSH
RUN update-rc.d ssh defaults \
    && ssh-keygen -N "" -f /root/.ssh/id_rsa

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
