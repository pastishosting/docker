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
