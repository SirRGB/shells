FROM docker.io/bitnami/minideb:bookworm

# Common build dependencies
RUN install_packages \
    ca-certificates \
    curl \
    gnupg \
    ncurses-bin \
    wget


###################################
## PowerShell
# Download and install the Microsoft repository GPG keys
RUN wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb --directory-prefix=/tmp
RUN dpkg -i /tmp/packages-microsoft-prod.deb

# Install PowerShell
RUN install_packages \
     powershell


###################################
## (Enhanced) Thompson Shell
# Install dependencies
RUN install_packages \
    gcc \
    make \
    libc-dev

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


###################################
## Z Shell
RUN install_packages \
    zsh


###################################
## C Shell
RUN install_packages \
    csh


###################################
## Friendly Interactive Shell
RUN install_packages \
    fish


###################################
## Korn Shell
RUN install_packages \
    ksh


###################################
## Teken C Shell
RUN install_packages \
    tcsh


###################################
## xonsh
RUN install_packages \
    xonsh

RUN curl -fsSL https://apt.fury.io/nushell/gpg.key | gpg --dearmor -o /etc/apt/trusted.gpg.d/fury-nushell.gpg
RUN echo "deb https://apt.fury.io/nushell/ /" | tee /etc/apt/sources.list.d/fury.list


###################################
## nushell
RUN install_packages \
    nushell


###################################
## elvish
RUN install_packages \
     elvish

###################################
# Cleanup
RUN rm /tmp/packages-microsoft-prod.deb /tmp/etsh-current-24.tar.gz
RUN apt remove -y \
    ca-certificates \
    curl \
    gcc \
    gnupg \
    make \
    libc-dev \
    wget

RUN apt autoremove -y

WORKDIR /root
