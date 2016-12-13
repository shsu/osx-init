#!/usr/bin/env ruby
require 'pty'

def prompt(*args)
    print(*args)
    gets
end

def run_cmd(cmd)
  begin
    PTY.spawn(cmd) do |stdout, stdin, pid|
      begin
        stdout.each { |line| print line }
      rescue Errno::EIO
        puts "Errno:EIO error; process has finished giving output."
      end
    end
  rescue PTY::ChildExited
    puts "The child process exited!"
  end
end

def run_brew(command, items)
  items.each { |item|
    run_cmd("brew #{command} #{item}")
  }
end

# Get brew!
# run_cmd('ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"')

# Update existing shells
run_brew('install', [
  'bash',
  'bash-completion',
  'zsh'
])

# Get Preferred Shell
fish = prompt "Use fish Shell? (yes/no) "
if fish == 'yes'
  run_cmd('echo /usr/local/bin/fish | sudo tee -a /etc/shells && sudo chsh -s /usr/local/bin/fish `whoami`')
  run_brew('tap', ['
    brew tap fisherman/tap
  '])
  run_brew('install', [
    'fish',
    'fisherman'
  ])
else
  run_cmd('sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"')
end

# Updating System Dependencies
run_brew('tap', ['homebrew/dupes'])
run_brew('install', [
  'awk',
  'coreutils',
  'findutils',
  'gnu-sed --with-default-names',
  'grep --with-default-names',
  'less',
  'rsync',
  'screen',
  'whois',
  'vim --override-system-vi',
  'brew install wget --with-iri'
])

# System Tools
run_brew('install', [
  'htop',
  'rename',
  'rlwrap',
  'pigz',
  'trash',
  'tree',
  'watch'
])

# Development Tools
if fish == 'no'
  run_brew('install', ['nvm'])
end

run_cmd('pip install -U pip setuptools')
run_cmd('gem install bundler pry \
  && number_of_cores=$(sysctl -n hw.ncpu) \
  && bundle config --global jobs $(number_of_cores - 1)')

run_brew('install', [
  'diff-so-fancy',
  'git-lfs',
  'imagemagick',
  'python',
  'sqlite',
  'asciinema',            # https://asciinema.org/
  'ccat',                 # https://github.com/jingweno/ccat
  'git-flow-avh',         # https://github.com/petervanderdoes/gitflow-avh
  'fpp',                  # https://github.com/facebook/PathPicker
  'httpie',               # https://httpie.org/
  'hh',                   # https://github.com/dvorka/hstr
  'hub',                  # https://hub.github.com/
  'jq',                   # https://github.com/stedolan/jq
  'mackup',               # https://github.com/lra/mackup
  'tig',                  # https://github.com/jonas/tig
  'the_silver_searcher',  # https://github.com/ggreer/the_silver_searcher
  'yank'                  # https://github.com/mptre/yank
])

# Database
mariadb = prompt "Install MariaDB? (yes/no) "
if mariadb == 'yes'
  run_cmd('brew tap homebrew/services \
    && brew install mariadb \
    && brew services start mariadb')
end

# Devops
devops = prompt "Install devops tools? (yes/no) "
if devops == 'yes'
  run_brew('install', [
    'ansible',
    'aria2',
    'aws-shell',
    'geoip --with-geoipupdate',
    'vegeta',
    'speedtest_cli'
  ])
  run_cmd('pip install -U awscli boto s3cmd')
end

latest_git_ssh = prompt "Install latest git and ssh? (yes/no) "
if latest_git_ssh == 'yes'
  run_brew('install', [
    'git --with-blk-sha1 --with-brewed-curl --with-brewed-openssl --with-persistent-https',
    'openssh',
    'ssh-copy-id'
  ])
end

run_cmd('brew cleanup')

puts 'Add the following to your desired shell configuration file:

PATH="/usr/local/opt/coreutils/libexec/gnubin:/usr/local/opt/findutils/libexec/gnubin:$PATH"
MANPATH="/usr/local/opt/coreutils/libexec/gnuman:/usr/local/opt/findutils/libexec/gnuman:$MANPATH"

export NVM_DIR="$HOME/.nvm"
. "/usr/local/opt/nvm/nvm.sh"'
