FROM docker.io/bitnami/minideb:trixie

###################################
## Install build dependencies
ARG BUILD_PACKAGES="\
    ca-certificates \
    curl \
    g++ \
    gcc \
    gnupg \
    make \
    libc-dev \
    wget \
    parallel"

RUN install_packages \
    ${BUILD_PACKAGES} \
## Download and install shell dependencies
    ncurses-bin
RUN mkdir --parents /opt/etsh /opt/hilbish
RUN parallel wget --directory-prefix=/tmp ::: \
    http://ftp.debian.org/debian/pool/main/i/icu/libicu72_72.1-3+deb12u1_amd64.deb \
    https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb \
    https://etsh.dev/src/current/snapshots/etsh-current-24/etsh-current-24.tar.gz \
    https://github.com/magicant/yash/releases/download/2.59/yash-2.59.tar.gz \
    https://github.com/adam-mcdaniel/dune/releases/download/v0.1.9/dune_linux_v0.1.9 \
    https://github.com/sammy-ette/Hilbish/releases/download/v2.3.4/hilbish-v2.3.4-linux-amd64.tar.gz \
    https://github.com/atinylittleshell/gsh/releases/download/v0.22.2/gsh_Linux_x86_64.tar.gz \
    https://oils.pub/download/oils-for-unix-0.35.0.tar.gz \
    https://github.com/ClementNerma/ReShell/releases/download/v0.1.0-1445/reshell-repl-x86_64-unknown-linux-musl.tgz
RUN dpkg --install /tmp/libicu72_72.1-3+deb12u1_amd64.deb

## Extract archives
RUN parallel tar zxf ::: \
    /tmp/etsh-current-24.tar.gz /tmp/hilbish-v2.3.4-linux-amd64.tar.gz ::: \
    --directory=/opt/etsh --directory=/opt/hilbish

RUN parallel tar zxf {} --directory=/tmp ::: \
    /tmp/yash-2.59.tar.gz \
    /tmp/oils-for-unix-0.35.0.tar.gz \
    /tmp/gsh_Linux_x86_64.tar.gz \
    /tmp/reshell-repl-x86_64-unknown-linux-musl.tgz


###################################
## Configure and install shells

RUN parallel ::: \
## PowerShell
    # Install the Microsoft repository GPG keys
    "dpkg --install /tmp/packages-microsoft-prod.deb" \
## Nushell
    # Download and install the Nushell repository GPG keys
    "curl -fsSL https://apt.fury.io/nushell/gpg.key | gpg --dearmor -o /etc/apt/trusted.gpg.d/fury-nushell.gpg && \
    echo 'deb https://apt.fury.io/nushell/ /' | tee /etc/apt/sources.list.d/fury.list"

RUN parallel ::: \
## (Enhanced) Thompson Shell
    "cd /opt/etsh/etsh-current-24 && ./configure && make etsh tsh && \
    # Symlink for usage
    ln --symbolic /opt/etsh/etsh-current-24/tsh /usr/local/bin/tsh && \
    ln --symbolic /opt/etsh/etsh-current-24/etsh /usr/local/bin/etsh" \
## yet another shell
    "cd /tmp/yash-2.59 && ./configure --disable-lineedit && make install" \
## Oils
    "cd /tmp/oils-for-unix-0.35.0 && ./configure && ./_build/oils.sh && ./install" \
"install_packages \
# PowerShell
    powershell \
# Z Shell
    zsh \
# Friendly Interactive Shell
    fish \
# Korn Shell
    ksh \
# Teken C Shell
    tcsh \
# Xonsh
    xonsh \
# Nushell
    nushell \
# Elvish Shell
    elvish \
# rc
    rc"

## dune
RUN mv /tmp/dune_linux_v0.1.9 /usr/local/bin/dune && chmod 770 /usr/local/bin/dune

# gsh
RUN mv /tmp/gsh /usr/local/bin

# reshell
RUN mv /tmp/reshell /usr/local/bin


###################################
## Cleanup
RUN apt remove -y \
    ${BUILD_PACKAGES}

WORKDIR /root
RUN apt autoremove -y
RUN rm --recursive --force /tmp/* /etc/apt/sources.list.d/fury.list

# Remove Thompson Shell source code
RUN find /opt/etsh/ -type f ! -name "tsh" ! -name "etsh" -exec rm {} \;

COPY ./README.md /root
COPY ./*.sh /root
COPY ./*.ps1 /root
