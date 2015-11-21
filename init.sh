#!/bin/sh

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Get brew!
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Set up a nice shell
brew install fish mobile-shell the_silver_searcher
echo /usr/local/bin/fish | sudo tee -a /etc/shells
sudo chsh -s /usr/local/bin/fish `whoami`
brew install caskroom/cask/brew-cask
brew tap caskroom/fonts
brew install font-source-code-pro font-source-code-pro-for-powerline

# Install a modern version of System Tools
brew tap homebrew/dupes
brew install curl --with-c-ares --with-libidn --with-libmetalink --with-libssh2 --with-nghttp2 --with-rtmpdump
brew install bash less screen rsync unzip whois
brew install openssh --with-brewed-openssl --with-ldns --with-keychain-support
brew install vim --override-system-vi

# Update Git
brew install git --with-blk-sha1 --with-brewed-curl --with-brewed-openssl --with-pcre --with-persistent-https
brew install fpp git-flow-avh git-lfs tig

# Core Libraries and Tools
brew install coreutils findutils hub moreutils pigz tree watch watchman #TODO path change for corutils
# ~/.config/fish/config.fish
brew install wget --with-iri
brew install imagemagick --with-webp
brew install jq speedtest_cli ssh-copy-id

# Ruby
brew install chruby-fish ruby-install
# source /usr/local/share/chruby/auto.fish
# source /usr/local/share/chruby/chruby.fish
ruby-install ruby 2.2
chruby ruby 2.2
gem install bundler pry
number_of_cores=$(sysctl -n hw.ncpu)
bundle config --global jobs $((number_of_cores - 1))
echo ruby-2.2 > ~/.ruby-version

# Python
brew install python
pip install -U pip setuptools
pip install -U awscli boto s3cmd

# node.js
brew install node --with-openssl
npm install -g bower grunt gulp json sitespeed.io yo

# Go
brew install go --with-cc-common

# Databases
brew install mongodb postgresql redis

# Messaging
brew install zeromq --with-libsodium --with-libpgm

# Devops
brew install ansible packer

# Docker
brew install docker docker-compose docker-machine

# Remove outdated versions from the cellar.
brew cleanup
