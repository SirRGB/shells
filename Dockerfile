FROM docker.io/debian:trixie-slim AS builder

###################################
## Install build dependencies
ENV USER="root"

RUN DEBIAN_FRONTEND=noninteractive apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates \
    cargo \
    curl \
    g++ \
    gcc \
    gnupg \
    make \
    libc-dev \
    libssl-dev \
    wget \
    parallel \
    pkg-config \
    unzip
RUN mkdir --parents /opt/hilbish
RUN parallel wget --directory-prefix=/tmp ::: \
    http://ftp.debian.org/debian/pool/main/i/icu/libicu72_72.1-3+deb12u1_amd64.deb \
    https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb \
    https://etsh.dev/src/current/snapshots/etsh-current-24/etsh-current-24.tar.gz \
    https://github.com/magicant/yash/releases/download/2.59/yash-2.59.tar.gz \
    https://github.com/sammy-ette/Hilbish/releases/download/v2.3.4/hilbish-v2.3.4-linux-amd64.tar.gz \
    https://github.com/atinylittleshell/gsh/releases/download/v0.22.2/gsh_Linux_x86_64.tar.gz \
    https://oils.pub/download/oils-for-unix-0.35.0.tar.gz \
    https://github.com/ClementNerma/ReShell/releases/download/v0.1.0-1445/reshell-repl-x86_64-unknown-linux-musl.tgz \
    https://github.com/tomhrr/cosh/archive/refs/heads/main.zip

## Extract archives
RUN tar zxf /tmp/hilbish-v2.3.4-linux-amd64.tar.gz --directory=/opt/hilbish
RUN parallel tar zxf {} --directory=/tmp ::: \
    /tmp/etsh-current-24.tar.gz \
    /tmp/yash-2.59.tar.gz \
    /tmp/oils-for-unix-0.35.0.tar.gz \
    /tmp/gsh_Linux_x86_64.tar.gz \
    /tmp/reshell-repl-x86_64-unknown-linux-musl.tgz

RUN unzip /tmp/main.zip -d /tmp

###################################
## Configure and install shells

RUN parallel ::: \
## (Enhanced) Thompson Shell
    "cd /tmp/etsh-current-24 && ./configure && make etsh tsh" \
## yet another shell
    "cd /tmp/yash-2.59 && ./configure --disable-lineedit && make install" \
## Oils
    "cd /tmp/oils-for-unix-0.35.0 && ./configure && ./_build/oils.sh && ./install" \
## cosh
    "cd /tmp/cosh-main && make && make install" \
## ion
    "cargo install --git https://gitlab.redox-os.org/redox-os/ion ion-shell" \
## Nushell
    # Download and install the Nushell repository GPG keys
    "curl -fsSL https://apt.fury.io/nushell/gpg.key | gpg --dearmor -o /etc/apt/keyrings/fury-nushell.gpg" \
## dune
    "cargo install dune"


FROM docker.io/debian:trixie-slim AS runner
ARG INSTALL_PATH=/usr/local/bin

## yet another shell
COPY --from=builder /usr/local/bin/yash "${INSTALL_PATH}"/yash
COPY --from=builder /usr/local/lib/share/yash/* "${INSTALL_PATH}"/../share/yash/
## Oils
COPY --from=builder /usr/local/bin/osh /usr/local/bin/ysh /usr/local/bin/oils-for-unix "${INSTALL_PATH}"/
## cosh
COPY --from=builder /usr/local/bin/cosh "${INSTALL_PATH}"/cosh
COPY --from=builder /usr/local/lib/cosh/* "${INSTALL_PATH}"/../lib/cosh/
## (Enhanced) Thompson Shell
COPY --from=builder /tmp/etsh-current-24/tsh /tmp/etsh-current-24/etsh "${INSTALL_PATH}"/
## dune
COPY --from=builder /root/.cargo/bin/dunesh "${INSTALL_PATH}"/dunesh
## gsh
COPY --from=builder /tmp/gsh "${INSTALL_PATH}"/gsh
## reshell
COPY --from=builder /tmp/reshell "${INSTALL_PATH}"/reshell
## ion
COPY --from=builder /root/.cargo/bin/ion "${INSTALL_PATH}"/ion

## Nushell
    # Download and install the Nushell repository GPG keys
COPY --from=builder /etc/apt/keyrings/fury-nushell.gpg /etc/apt/keyrings/fury-nushell.gpg
RUN echo 'deb [signed-by=/etc/apt/keyrings/fury-nushell.gpg] https://apt.fury.io/nushell/ /' | tee /etc/apt/sources.list.d/fury.list

## PowerShell
COPY --from=builder /tmp/packages-microsoft-prod.deb /tmp/libicu72_72.1-3+deb12u1_amd64.deb /tmp/
RUN DEBIAN_FRONTEND=noninteractive apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    # Install the Microsoft repository GPG keys
    ca-certificates && \
    dpkg --install /tmp/packages-microsoft-prod.deb /tmp/libicu72_72.1-3+deb12u1_amd64.deb
RUN DEBIAN_FRONTEND=noninteractive apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
# clear
    ncurses-bin	\
## PowerShell
    powershell \
## Z Shell
    zsh \
## Friendly Interactive Shell
    fish \
## Korn Shell
    ksh \
## Teken C Shell
    tcsh \
## Xonsh
    xonsh \
## Nushell
    nushell \
## Elvish Shell
    elvish \
## rc
    rc

###################################
## Cleanup
WORKDIR /root
RUN rm --recursive /var/lib/apt/lists /var/cache/apt/archives /tmp/*

COPY ./README.md ./*.sh ./*.ps1 /root
