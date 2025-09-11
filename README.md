# UNIX Shells and more
---
All sizes are taken from du, which uses factors of 1024 i.e. Kibibyte/Mebibyte

Name | aliases | path | size
---|---|---|---|
[Bourne Again Shell](https://cgit.git.savannah.gnu.org/cgit/bash.git) | bash, rbash | /bin/rbash -> /bin/bash | 1.3M
[Debian Almquist Shell](http://gondor.apana.org.au/~herbert/dash) | sh, dash | /bin/sh -> /bin/dash |124K
[Powershell](https://learn.microsoft.com/en-us/powershell/scripting/install/install-debian?view=powershell-7.5) | pwsh | /opt/microsoft/powershell/7/pwsh -> /usr/bin/pwsh | 76K
[Thompson Shell](https://etsh.dev/src) | tsh, etsh | /usr/local/bin/tsh -> /opt/etsh/etsh-current-24/tsh<br>/usr/local/bin/etsh -> /opt/etsh/etsh-current-24/etsh | 40K, 88K
[Z Shell](https://www.zsh.org) | zsh, rzsh | /usr/bin/rzsh -> /usr/bin/zsh | 848K
[Friendly Interactive Shell](https://fishshell.com) | fish | /usr/bin/fish | 1.8M
[Korn Shell](http://kornshell.com) | ksh, ksh93, rksh | /usr/bin/ksh -> /bin/ksh93<br>/usr/bin/rksh -> /bin/ksh93 | 1.5M
[TENEX C Shell](https://www.tcsh.org) | tcsh, csh | /usr/bin/tcsh<br>/usr/bin/csh -> /usr/bin/tcsh | 424K
[xonsh](https://xon.sh) | xonsh | /usr/bin/xonsh | 6.3M
[nushell](https://www.nushell.sh) | nu | /usr/bin/nu | 44M
[elvish](https://elv.sh) | elvish | /usr/bin/elvish | 7.9M
[yet another shell](https://github.com/magicant/yash/blob/trunk/INSTALL) | yash | /usr/local/bin/yash | 1.2M
[dune](https://github.com/adam-mcdaniel/dune) | dune | /usr/local/bin/dune | 7.2M
[oils](https://github.com/oils-for-unix/oils/blob/master/INSTALL.txt) | osh, ysh | /usr/local/bin/osh -> /usr/local/bin/oils-for-unix<br>/usr/local/bin/ysh -> /usr/local/bin/oils-for-unix | 2.4M
[Hilbish](https://github.com/sammy-ette/Hilbish) | cd /opt/hilbish/<br>./hilbish | /opt/hilbish/hilbish | 8.6M
[rc](https://github.com/rakitzis/rc) | rc | /usr/bin/rc -> /usr/bin/rc.byron | 120K
[gsh](https://github.com/atinylittleshell/gsh) | gsh | /usr/local/bin/gsh | 21M
[reshell](https://github.com/ClementNerma/ReShell) | reshell | /usr/bin/reshell | 12M
[ion](https://gitlab.redox-os.org/redox-os/ion) |ion | /usr/local/bin/ion | 3.6M


### Makefile
- make all
  - build and run the container
- make build
  - build the container
- make run
  - run and enter the container
