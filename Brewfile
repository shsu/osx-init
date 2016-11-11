#!/bin/sh

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Get brew!
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install brew plugins
brew tap homebrew/dupes
brew tap homebrew/services
# brew tap homebrew/versions

# Install Shells
brew install bash bash-completion fish mobile-shell

read -p "Use fish as default shell? " -n 1 -r
echo # move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
  echo /usr/local/bin/fish | sudo tee -a /etc/shells
  sudo chsh -s /usr/local/bin/fish `whoami`
  brew tap fisherman/tap
  brew install fisherman
  fisher z
fi

# Updating System Dependencies
brew install awk coreutils findutils less screen rsync whois
brew install vim --override-system-vi
brew install gnu-sed --with-default-names
brew install grep --with-default-names
brew install wget --with-iri

# System Tools
brew install htop rename rlwrap pigz trash tree watch

# Development Tools
brew install git-lfs imagemagick nvm python sqlite ssh-copy-id
pip install -U pip setuptools
pip install -U awscli boto s3cmd

brew install asciinema            # https://asciinema.org/
brew install ccat                 # https://github.com/jingweno/ccat
brew install git-flow-avh         # https://github.com/petervanderdoes/gitflow-avh
brew install fpp                  # https://github.com/facebook/PathPicker
brew install httpie               # https://httpie.org/
brew install hh                   # https://github.com/dvorka/hstr
brew install hub                  # https://hub.github.com/
brew install jq                   # https://github.com/stedolan/jq
brew install mackup               # https://github.com/lra/mackup
brew install tig                  # https://github.com/jonas/tig
brew install the_silver_searcher  # https://github.com/ggreer/the_silver_searcher
brew install yank                 # https://github.com/mptre/yank

# Devops
brew install ansible aws-shell vegeta
brew install geoip --with-geoipupdate

# Other
brew install aria2 speedtest_cli

read -p "Do you want to install latest git and ssh? " -n 1 -r
echo # move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
  brew install git --with-blk-sha1 --with-brewed-curl --with-brewed-openssl --with-persistent-https
  brew install openssh
fi

read -p "Do you want to install ch-ruby? " -n 1 -r
echo # move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
  brew install chruby-fish ruby-install
  source /usr/local/share/chruby/chruby.fish

  ruby-install ruby 2.3
  chruby ruby 2.3

  gem install bundler pry
  number_of_cores=$(sysctl -n hw.ncpu)
  bundle config --global jobs $((number_of_cores - 1))
fi

read -p "Do you want to install youtube-dl? " -n 1 -r
echo # move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
  # https://github.com/rg3/youtube-dl/blob/master/README.md#format-selection-examples
  brew install ffmpeg #--with-fdk-aac --with-libvorbis
  brew install youtube-dl
fi

brew cleanup

echo 'Add the following to your desired shell configuration file:

PATH="/usr/local/opt/coreutils/libexec/gnubin:/usr/local/opt/findutils/libexec/gnubin:$PATH"
MANPATH="/usr/local/opt/coreutils/libexec/gnuman:/usr/local/opt/findutils/libexec/gnuman:$MANPATH"

export NVM_DIR="$HOME/.nvm"
. "/usr/local/opt/nvm/nvm.sh"'
