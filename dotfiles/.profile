# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ "$BASH_VERSION" != "" ]; then
	# include .bashrc if it exists
	if [ -f "$HOME/.bashrc" ]; then
		. "$HOME/.bashrc"
	fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ]; then
	PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ]; then
	PATH="$HOME/.local/bin:$PATH"
fi

# expand aliases needed by nvim
export BASH_ENV="$HOME/.bash_env"

export JAVA_HOME=/opt/java
export PATH="$JAVA_HOME/bin:$PATH"

export GOPATH="$HOME/.gopath"
export GOBIN="$GOPATH/bin"
export PATH="$GOBIN:$PATH"

export PATH="/usr/lib/postgresql/16/bin:$PATH"

export PATH="$PATH:/opt/cosmocc/bin"

export EMSDK_QUIET=1
test -f /opt/emsdk/emsdk_env.sh && source /opt/emsdk/emsdk_env.sh

test -f ~/.cargo/env && source ~/.cargo/env

test -f ~/.ghcup/env && source ~/.ghcup/env

test -f ~/.xmake/profile && source ~/.xmake/profile

if [ -e /home/hacker/.nix-profile/etc/profile.d/nix.sh ]; then . /home/hacker/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

exec zsh
