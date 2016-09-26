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
    && ssh-keygen -N "" -f /root/.ssh/id_rsa \
    && echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDBtkxRXehGPwJ0KKcyrXq9o2/hfEt06vjcZLakRWHMaJD0WTJrKNNn1Mq+bKf6wJkTW2CWDnjiTMFcqQaTUQfn0bcNhnPgZ6zyYFd/SiC2kZRuvnVYP2kV7MZMvgnEQjrpxCd7mxOmhih1gv68SSk94MmEVXBhjQEVZsFJHyBaNp++NY2+JsjYyuFwPURH+3XcJS3H8QEyVOnnFzJ7ZOo/egk3FoQMmbljgSHMg/jgrIQIAMtFS2PFa0oLUH6+nAZpbS4mNufN7L6T5iwgMAkbrO3Ff/1tQIOu3t/bHKUtwmeUMuKdAz0m2Hu/LImcJBz45u1vsr6ED3qLEEbk9yfx tristan" >> /root/.ssh/authorized_keys \

# Setup ProFTPd
RUN echo "PassivePorts 30000 30009" > /etc/proftpd.d/pastis-hosting.conf

# Setup Postfix
RUN sed -i '/^myhostname/ d' /etc/postfix/main.cf \
    && sed -i '/^mydestination/ d' /etc/postfix/main.cf \
    && echo "myhostname=plesk.pastis-hosting.net" >> /etc/postfix/main.cf \
    && echo "mydestination=/etc/mailname, pastis-hosting.net, localhost.localdomain, localhost"

# Setup Mailjet
ARG MAILJET_API_KEY=get_from_mailjet_website
ARG MAILJET_SECRET_KEY=get_from_mailjet_website
RUN sed -i '/^relayhost/ d' /etc/postfix/main.cf \
    && sed -i '/^smtp_sasl_auth_enable/ d' /etc/postfix/main.cf \
    && sed -i '/^smtp_sasl_password_maps/ d' /etc/postfix/main.cf \
    && echo "relayhost=in-v3.mailjet.com" >> /etc/postfix/main.cf \
    && echo "smtp_sasl_auth_enable=yes" >> /etc/postfix/main.cf \
    && echo "smtp_sasl_password_maps=hash:/etc/postfix/sasl_passwd" >> /etc/postfix/main.cf \
    && echo "in-v3.mailjet.com $MAILJET_API_KEY:$MAILJET_SECRET_KEY" > /etc/postfix/sasl_passwd \
    && chown root:root /etc/postfix/sasl_passwd \
    && chmod 600 /etc/postfix/sasl_passwd \
    && postmap /etc/postfix/sasl_passwd

# Upgrade Plesk
# ERROR: The executed process was terminated because of unhandled signal received from the system.
# RUN /opt/psa/admin/sbin/autoinstaller --select-product-id plesk --select-release-current --reinstall-patch --install-component panel
