FROM ubuntu:lunar

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.name="My work environ XPRA Ubuntu" \
    org.label-schema.description="XPRA Remote Desktop, additional depends for emacs and more" \
    org.label-schema.url="https://neuhalfen.name" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url="https://github.com/neuhalje/xpra-work-env" \
    org.label-schema.vendor="Jens Neuhalfen" \
    org.label-schema.version=$VERSION \
    org.label-schema.schema-version="1.0.0"

ENV DEBIAN_FRONTEND=noninteractive
ENV UID=1000
ENV USER_NAME=ubuntu
ENV XPRA_PORT=9876

RUN uname -a

# This has to run before adding any non-ubuntu repos (es. ca-certificates)
RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get update  && \
    apt-get install -y ca-certificates wget gnupg2 apt-transport-https 

# install XPRA.
COPY xpra.gpg /usr/share/keyrings/xpra.gpg
RUN echo "deb [arch=amd64 signed-by=/usr/share/keyrings/xpra.gpg] https://xpra.org/ lunar main" > /etc/apt/sources.list.d/xpra.list

# gopass
COPY gopass.gpg /usr/share/keyrings/gopass-archive-keyring.gpg
COPY gopass.sources /etc/apt/sources.list.d/gopass.sources

RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get update  && \
    apt-get dist-upgrade -y  && \
    apt-get install -y qemu-user-static && \
    apt-get install -y sudo && \
    usermod -aG sudo ${USER_NAME} 

RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y \
        gopass 

RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y \
        libarchive-tools \
        \
        rsync \
        apt-utils \
        software-properties-common \
        curl \
        \
        git \
        gnupg \
        rng-tools 

RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y \
        gdm3 \
        glances \
        libqt5x11extras5 \
        nautilus \
        tasksel \
        \
        kitty

RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y \
        xpra  \
        xvfb  \
        xsel \
        xclip

RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y \
        sshfs  \
        \
        aspell \
        aspell-de \
        aspell-en \
        libenchant-2-dev \
        pkg-config \
        \
        libxml2-dev \
        libcurl4-openssl-dev \
        libssl-dev \
        \
        cmake \
        build-essential \
        libtool-bin\
        \
        software-properties-common \
        \
        neovim \
        krita \
        \
        fonts-league-mono \
        fonts-noto-mono \
        fonts-arkpandora \
        fonts-powerline \
        \
        bat \
        fzf \
        gnuplot \
        graphviz \
        htop \
        pandoc \
        ripgrep \
        silversearcher-ag \
        sysstat \
        tj3 \
        tmux \
        zsh \
        \
        dnsutils \
        httping \
        iproute2 \
        iputils-ping \
        net-tools \
        nmap \
        openssh-server \
        sshfs \
        sslscan

RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y \
        inkscape \
        inkscape-open-symbols 

RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y \
        python3-pip \
        python3-nwdiag 

RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y \
        evince \
        \
        gimp \
        \
        yarn \
        npm && \
        \
        apt remove --autoremove emacs emacs-common && \
        /usr/bin/add-apt-repository ppa:neuhalje/emacs-stable && \
        DEBIAN_FRONTEND=noninteractive apt-get install -y emacs29


RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y \
        default-jre-headless

# this fails to install on podman/M1
# RUN DEBIAN_FRONTEND=noninteractive && \
#     apt-get install -y \
#         latexmk  \
#         tex-common
# 
# RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
#         texlive-xetex 
# 
# RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
#         texlive-lang-german \
#         texlive-latex-extra \
#         texlive-metapost \
#         texlive-pictures \
#         texlive-pstricks \
#         texlive-science \
#         texlive-fonts-extra 
# 
# RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
#         latexdiff \
#         dvipng \
#         biber 

RUN apt-get clean
RUN echo "LANG=en_US.UTF-8" >> /etc/locale.conf

RUN echo 'ALL ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

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
#RUN apt-get install -y libpam-fscrypt && \
#    mkdir /home/${USER_NAME}/protected && \
#    chown ${USER_NAME}:${USER_NAME} /home/${USER_NAME}/protected && \
#    fscrypt setup --quiet --force && \
#    echo "fscrypt setup /home/${USER_NAME}/protected --quiet && fscrypt encrypt /home/${USER_NAME}/protected" > /home/${USER_NAME}/protected_setup.sh && chmod 755  /home/${USER_NAME}/protected_setup.sh

# emacs pdf-tools (https://github.com/politza/pdf-tools) deps
# org-roam (libsqlite3-dev) deps
RUN apt-get install -y libpoppler-glib-dev libpoppler-private-dev libpng-dev zlib1g-dev libsqlite3-dev sqlite3

# https://www.nerdfonts.com/font-downloads for the win!
RUN mkdir -p  /usr/local/share/fonts && \
    wget -q -O - https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.0/FiraCode.zip | bsdtar -xvf - --cd /usr/local/share/fonts && \
    wget -q -O - https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.0/Hack.zip | bsdtar -xvf - --cd /usr/local/share/fonts && \
    wget -q -O - https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.0/Overpass.zip | bsdtar -xvf - --cd /usr/local/share/fonts && \
    wget -q -O - https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.0/Arimo.zip | bsdtar -xvf - --cd /usr/local/share/fonts && \
    fc-cache -f -v

# Signal
#RUN wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > /usr/share/keyrings/signal-desktop-keyring.gpg && \
#          echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' > /etc/apt/sources.list.d/signal-xenial.list && \
#          apt update && sudo apt install signal-desktop


########################
# Babashka
COPY babashka-installer /tmp/babashka-installer 
RUN  /tmp/babashka-installer 

#######################################################################
## User Configuration
# Sudo configuration

RUN umask 0077 && mkdir -p /run/user/${UID}/xpra
RUN umask 0077 && mkdir -p /run/xpra/pki
RUN chown -R ${USER_NAME}:${USER_NAME} /run/user/${UID} 
RUN chown -R ${USER_NAME}:${USER_NAME} /run/xpra

RUN apt-get update && apt-get install -y sudo
RUN usermod -aG sudo ${USER_NAME}
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Install various fonts
COPY install-fonts.sh /tmp/.
RUN  chmod 555 /tmp/install-fonts.sh

RUN chsh -s $(which zsh) ${USER_NAME}
USER ${USER_NAME}
RUN  /tmp/install-fonts.sh
    
ENV DISPLAY=:100

WORKDIR /home/${USER_NAME}
COPY README.md /


EXPOSE ${XPRA_PORT}

COPY start-xpra.sh /
CMD /start-xpra.sh ${XPRA_PORT}
