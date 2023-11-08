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

RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get update  && \
    apt-get install -y \
        ca-certificates \
        wget \
        gnupg2 \
        apt-transport-https

# install XPRA.
# as of today (2023-11-1) there are no mantic packages available, so fallback to lunar
# @future me: https://xpra.org/dists/mantic/main/binary-amd64/
COPY --chmod=444 xpra.gpg /usr/share/keyrings/xpra.gpg
COPY --chmod=444 xpra.list /etc/apt/sources.list.d/xpra.list

# gopass
COPY --chmod=444 gopass.gpg /usr/share/keyrings/gopass-archive-keyring.gpg
COPY --chmod=444 gopass.list /etc/apt/sources.list.d/gopass.list

# This has to run before adding any non-ubuntu repos (es. ca-certificates)
RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get update  && \
    apt-get dist-upgrade -y

RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y sudo && \
    usermod -aG sudo ${USER_NAME} 

    #TODO Needed that for something??? libglib2.0-0 libxext6 libsm6 libxrender1 


RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y \
        gopass 

RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y \
        python3-pip \
        python3-jeepney \
        python3-apt

RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y \
        libarchive-tools \
        \
        rsync \
        apt-utils \
        curl \
        \
        git \
        gnupg \
        rng-tools  \
        wget \
        bzip2 \
        ca-certificates \
        screen \
        git \
        rlwrap

RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y \
        software-properties-common

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
        neovim \
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
        python3-nwdiag  
        #python3-more-itertools

RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y \
        yarn \
        npm

RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y \
       openjdk-11-jdk \
       default-jre-headless


RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y qemu-user-static

RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y \
        xpra-server  \
        xvfb  \
        xsel \
        xclip

# deps for inkscape that it cannot resolve otherwise
# libpoppler126 somehow is missing from the central repo
#RUN DEBIAN_FRONTEND=noninteractive && \
#    wget http://launchpadlibrarian.net/649777340/libpoppler126_22.12.0-2ubuntu1_amd64.deb  && \
#    dpkg -i libpoppler126_22.12.0-2ubuntu1_amd64.deb || apt-get -f install ;   \
#    rm libpoppler126_22.12.0-2ubuntu1_amd64.deb

# use latest stable inkscape
#RUN DEBIAN_FRONTEND=noninteractive && \
#    /usr/bin/add-apt-repository ppa:inkscape.dev/stable && \
#    apt-get update && \
#    apt-get install -y \
#        inkscape

COPY --chmod=555 tmp/Inkscape.AppImage /opt/.

RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y \
        krita \
        \
        fonts-league-mono \
        fonts-noto-mono \
        fonts-arkpandora \
        fonts-powerline

RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y \
        evince \
        \
        gimp 

RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y \
        kitty


# this fails to install on podman/M1
RUN DEBIAN_FRONTEND=noninteractive && \
  apt-get install -y \
      latexmk  \
      tex-common
# 
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
         texlive-xetex 
# 
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
         texlive-lang-german \
         texlive-latex-extra

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
         texlive-pictures

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
         texlive-science \
         texlive-fonts-extra 
# 
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
         latexdiff \
         dvipng \
         biber 

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
         texlive-luatex

#RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
#         texlive-pstricks
#
#RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
#         texlive-metapost

# Install Clojure
RUN curl -L -O https://github.com/clojure/brew-install/releases/download/1.11.1.1413/linux-install.sh && \
    chmod +x linux-install.sh && \
    ./linux-install.sh && \
    rm ./linux-install.sh

# Install LSP: core-dumps
#RUN npm i -g \
#             vscode-langservers-extracted 


# Install LSP
RUN \
#    npm i -g \
#             graphql-language-service-cli && \
    npm i -g \
             yaml-language-server 
RUN \
    npm i -g \
             bash-language-server   && \
    npm i -g \
             unified-language-server 




RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get remove --autoremove emacs emacs-common && \
    /usr/bin/add-apt-repository ppa:neuhalje/emacs-stable && \
    apt-get update && \
    apt-get install -y emacs29



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
