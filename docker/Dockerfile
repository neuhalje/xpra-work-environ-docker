FROM ubuntu:hirsute

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.name="My work environ XPRA Ubuntu" \
    org.label-schema.description="XPRA Remote Desktop, additional depends for emacs and more" \
    org.label-schema.url="https://neuhalfen.name" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url="e.g. https://github.com/neuhalje/xpra-work-env" \
    org.label-schema.vendor="Jens Neuhalfen" \
    org.label-schema.version=$VERSION \
    org.label-schema.schema-version="1.0.0"

ENV DEBIAN_FRONTEND=noninteractive
ENV golang_version=1.16.5
ENV UID=1000
ENV USER_NAME=user
ENV XPRA_PORT=9876

# install XPRA: https://xpra.org/trac/wiki/Usage/Docker 
RUN apt-get update && \
    apt-get install -y wget gnupg2 apt-transport-https && \
    wget -O - https://xpra.org/gpg.asc | apt-key add - && \
    echo "deb https://xpra.org/ hirsute main" > /etc/apt/sources.list.d/xpra.list

RUN apt-get update && \
    apt-get install -y xpra \
    xvfb \
    xterm \
    sshfs && \
    apt-get clean && \ 
    rm -rf /var/lib/apt/lists/*

RUN apt-key list
    
# Add sudo to user
RUN adduser --disabled-password --gecos "me" --uid ${UID} ${USER_NAME}
RUN apt-get update && apt-get install -y sudo
RUN usermod -aG sudo ${USER_NAME}
RUN echo 'ALL ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# install all X apps here
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive && \
    apt-get clean && \ 
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
    apt-utils \
    build-essential \
    gdm3 \
    glances \
    glmark2 \
    gnome-shell \
    gnome-session \
    gnome-terminal \
    libqt5x11extras5 \
    linux-generic-hwe-20.04-edge \
    nautilus \
    seahorse-nautilus \
    software-properties-common \
    tasksel \
    neovim \
    emacs \
    \
    fonts-firacode \
    fonts-league-mono \
    fonts-noto-mono \
    \
    fzf \
    gopass \
    graphviz \
    htop \
    pandoc \
    python3-nwdiag \
    ripgrep \
    silversearcher-ag \
    tj3 \
    tmux \
    zsh \
    \
    dnsutils \
    httping \
    iputils-ping \
    nmap \
    \
    texlive-xetex \
    texlive-lang-german \
    texlive-latex-extra \
    texlive-metapost \
    texlive-pictures \
    texlive-pstricks \
    texlive-science \
    texlive-fonts-extra \
    \
    r-base \
    r-cran-rsvg



RUN echo "LANG=en_US.UTF-8" >> /etc/locale.conf

# Install Go
RUN wget -c https://dl.google.com/go/go${golang_version}.linux-amd64.tar.gz -O - | sudo tar -xz -C /usr/local


RUN apt-get install -y language-pack-en-base && \ 
    locale-gen en_US.UTF-8 && \ 
    update-locale LANG=en_US.UTF-8

RUN echo LANG="en_US.UTF-8" > /etc/default/locale
RUN echo en_US.UTF-8 UTF-8 >> /etc/locale.gen && locale-gen

# Setup time zone, language
ENV TZ Europe/Berlin
ENV LANG=C.UTF-8 
ENV LC_ALL "en_US.UTF-8"

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone

RUN apt-get update --fix-missing && apt-get install -y wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    screen \
    git subversion

# fscrypt -- encrypt ~/protected
RUN apt-get install -y libpam-fscrypt && \
    mkdir /home/${USER_NAME}/protected && \
    chown ${USER_NAME}:${USER_NAME} /home/${USER_NAME}/protected && \
    fscrypt setup --quiet --force && \
    echo "fscrypt setup /home/${USER_NAME}/protected --quiet && fscrypt encrypt /home/${USER_NAME}/protected" > /home/${USER_NAME}/protected_setup.sh && chmod 755  /home/${USER_NAME}/protected_setup.sh 

# emacs pdf-tools (https://github.com/politza/pdf-tools) deps
# org-roam (libsqlite3-dev) deps
RUN apt-get install -y libpoppler-glib-dev libpoppler-private-dev libpng-dev zlib1g-dev libsqlite3-dev sqlite

#######################################################################
## User Configuration
# Sudo configuration

RUN umask 0077 && mkdir -p /run/user/${UID}/xpra
RUN umask 0077 && mkdir -p /run/xpra/pki
RUN chown -R ${USER_NAME}:${USER_NAME} /run/user/${UID} 
# && chmod 700  /run/user/${UID}
RUN chown -R ${USER_NAME}:${USER_NAME} /run/xpra

RUN apt-get update && apt-get install -y sudo
RUN usermod -aG sudo ${USER_NAME}
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers


USER ${USER_NAME}

    
# set path for Go
ENV PATH=$PATH:/opt/VirtualGL/bin/:/usr/local/go/bin 

ENV DISPLAY=:100

WORKDIR /home/${USER_NAME}
COPY README.md /run/user/${UID}/.

EXPOSE ${XPRA_PORT}

COPY start-xpra.sh /run/${UID}/
CMD /run/${UID}/start-xpra.sh ${XPRA_PORT}
