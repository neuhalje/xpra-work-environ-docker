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
    org.label-schema.vcs-url="https://github.com/neuhalje/xpra-work-env" \
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

#RUN apt-get update && \
#    apt-get dist-upgrade && \
#    apt-get install -y \
    # && \
    #apt-get clean && \ 
    #rm -rf /var/lib/apt/lists/*

RUN apt-key list
    
# Add sudo to user
RUN adduser --disabled-password --gecos "me" --uid ${UID} ${USER_NAME}
RUN apt-get update && apt-get install -y sudo
RUN usermod -aG sudo ${USER_NAME}
RUN echo 'ALL ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN apt-get update &&  \
    DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y \
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
	    curl \
	    \
	    xpra  \
	    xvfb  \
	    xterm  \
	    sshfs  \
	    \
	    aspell \
	    aspell-de \
	    \
	    firefox \
	    \
	    neovim \
	    emacs \
	    \
	    fonts-league-mono \
	    fonts-noto-mono \
	    fonts-arkpandora \
	    fonts-powerline \
	    \
	    fzf \
	    gnuplot \
	    gopass \
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
	    sslscan \
	    \
	    texlive-xetex \
	    texlive-lang-german \
	    texlive-latex-extra \
	    texlive-metapost \
	    texlive-pictures \
	    texlive-pstricks \
	    texlive-science \
	    texlive-fonts-extra \
	    latexdiff \
	    dvipng \
	    biber \
	    inkscape \
	    latexmk \
	    \
	    evince \
	    \
	    r-base \
	    r-cran-rsvg \
	    libxml2-dev \
	    libcurl4-openssl-dev \
	    libssl-dev \
	    \
	    python3-pip\
	    python3-nwdiag && \
    apt-get clean

RUN echo "LANG=en_US.UTF-8" >> /etc/locale.conf

# Install Go
RUN wget -c https://dl.google.com/go/go${golang_version}.linux-amd64.tar.gz -O - | sudo tar -xz -C /usr/local

# Install Adopt OpenJDK
# Code from https://github.com/AdoptOpenJDK/openjdk-docker/blob/master/16/jdk/ubuntu/Dockerfile.hotspot.releases.full
ENV JAVA_VERSION jdk-16.0.1+9

RUN set -eux; \
    ARCH="$(dpkg --print-architecture)"; \
    case "${ARCH}" in \
       aarch64|arm64) \
         ESUM='3447ec27a6dbd4f3a6180a0d4371bb09aa428c16eea9983e515a7400cc9f5c85'; \
         BINARY_URL='https://github.com/AdoptOpenJDK/openjdk16-binaries/releases/download/jdk-16.0.1%2B9/OpenJDK16U-jdk_aarch64_linux_hotspot_16.0.1_9.tar.gz'; \
         ;; \
       armhf|armv7l) \
         ESUM='20fc395d8ea2659e6407cd4ec233dc4399f61b7610f3a16495deb23c1e3b81df'; \
         BINARY_URL='https://github.com/AdoptOpenJDK/openjdk16-binaries/releases/download/jdk-16.0.1%2B9/OpenJDK16U-jdk_arm_linux_hotspot_16.0.1_9.tar.gz'; \
         ;; \
       ppc64el|ppc64le) \
         ESUM='8d8e35ca5a7e24f16384bf32b110562921c19b4cfe65969980937bf879462bc6'; \
         BINARY_URL='https://github.com/AdoptOpenJDK/openjdk16-binaries/releases/download/jdk-16.0.1%2B9/OpenJDK16U-jdk_ppc64le_linux_hotspot_16.0.1_9.tar.gz'; \
         ;; \
       s390x) \
         ESUM='421cd44661cdbf0c2da79ab3104c81a1fa171b974038e55b1b3d4a042865588f'; \
         BINARY_URL='https://github.com/AdoptOpenJDK/openjdk16-binaries/releases/download/jdk-16.0.1%2B9/OpenJDK16U-jdk_s390x_linux_hotspot_16.0.1_9.tar.gz'; \
         ;; \
       amd64|x86_64) \
         ESUM='7fdda042207efcedd30cd76d6295ed56b9c2e248cb3682c50898a560d4aa1c6f'; \
         BINARY_URL='https://github.com/AdoptOpenJDK/openjdk16-binaries/releases/download/jdk-16.0.1%2B9/OpenJDK16U-jdk_x64_linux_hotspot_16.0.1_9.tar.gz'; \
         ;; \
       *) \
         echo "Unsupported arch: ${ARCH}"; \
         exit 1; \
         ;; \
    esac; \
    curl -LfsSo /tmp/openjdk.tar.gz ${BINARY_URL}; \
    echo "${ESUM} */tmp/openjdk.tar.gz" | sha256sum -c -; \
    mkdir -p /opt/java/openjdk; \
    cd /opt/java/openjdk; \
    tar -xf /tmp/openjdk.tar.gz --strip-components=1; \
    rm -rf /tmp/openjdk.tar.gz;

ENV JAVA_HOME=/opt/java/openjdk \
    PATH="/opt/java/openjdk/bin:$PATH"

###### ~OpenJDK

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

# Signal
RUN wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > /usr/share/keyrings/signal-desktop-keyring.gpg && \
          echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' > /etc/apt/sources.list.d/signal-xenial.list && \
          apt update && sudo apt install signal-desktop

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
COPY install-fonts.sh /run/user/${UID}/.
RUN  chmod 555 /run/user/${UID}/install-fonts.sh

USER ${USER_NAME}

    
# set path for Go
ENV PATH=$PATH:/opt/VirtualGL/bin/:/usr/local/go/bin 

ENV DISPLAY=:100

WORKDIR /home/${USER_NAME}
COPY README.md /run/user/${UID}/.

RUN  /run/user/${UID}/install-fonts.sh

EXPOSE ${XPRA_PORT}

COPY start-xpra.sh /run/${UID}/
CMD /run/${UID}/start-xpra.sh ${XPRA_PORT}
