FROM docker.io/bitnami/minideb:trixie

###################################
## Install build dependencies
RUN install_packages \
    ca-certificates \
    curl \
    gnupg \
    wget \
    gcc \
    make \
    libc-dev \
## Install shell dependencies
    ncurses-bin
RUN wget http://ftp.debian.org/debian/pool/main/i/icu/libicu72_72.1-3+deb12u1_amd64.deb --directory-prefix=/tmp
RUN dpkg --install /tmp/libicu72_72.1-3+deb12u1_amd64.deb


###################################
## Prepare install

## PowerShell
# Download and install the Microsoft repository GPG keys
RUN wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb --directory-prefix=/tmp
RUN dpkg --install /tmp/packages-microsoft-prod.deb


## (Enhanced) Thompson Shell
# Get the source
RUN wget https://etsh.dev/src/current/snapshots/etsh-current-24/etsh-current-24.tar.gz --directory-prefix=/tmp

# Create directories and extract source into it
RUN mkdir -p /opt/etsh/
RUN tar zxf /tmp/etsh-current-24.tar.gz -C /opt/etsh

# Build tsh and etsh
WORKDIR /opt/etsh/etsh-current-24/
RUN ./configure && make etsh tsh

# Symlink for usage
RUN ln -s /opt/etsh/etsh-current-24/tsh /bin/tsh
RUN ln -s /opt/etsh/etsh-current-24/etsh /bin/etsh


## Nushell
# Download and install the Nushell repository GPG keys
RUN curl -fsSL https://apt.fury.io/nushell/gpg.key | gpg --dearmor -o /etc/apt/trusted.gpg.d/fury-nushell.gpg
RUN echo "deb https://apt.fury.io/nushell/ /" | tee /etc/apt/sources.list.d/fury.list


## yet another shell
# Get the source
RUN wget https://github.com/magicant/yash/releases/download/2.59/yash-2.59.tar.gz --directory-prefix=/tmp
RUN tar zxf /tmp/yash-2.59.tar.gz -C /tmp/

# Build yash and install
WORKDIR /tmp/yash-2.59
RUN ./configure --disable-lineedit && make install


## dune
RUN wget --output-document dune https://github.com/adam-mcdaniel/dune/releases/download/v0.1.9/dune_linux_v0.1.9
RUN mv ./dune /bin && chmod 770 /bin/dune


###################################
## Install Shells
RUN install_packages \
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
    elvish


###################################
## Cleanup
RUN apt remove -y \
    ca-certificates \
    curl \
    gcc \
    gnupg \
    make \
    libc-dev \
    wget

RUN apt autoremove -y
RUN rm -rf /tmp/*

# Remove Thompson Shell source code
RUN find /opt/etsh/ -type f ! -name "tsh" ! -name "etsh" -exec rm -rf {} \;

COPY ./README.md /root
COPY ./*.sh /root
COPY ./*.ps1 /root
WORKDIR /root
