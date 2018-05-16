#!/bin/bash

while true; do
    read -p "asdf manager is going to be installed (Not tested)? y/n: " yn
    case $yn in
        [Yy]* ) echo "Installing..."; break;;
        [Nn]* ) exit;;
        * ) echo "Please enter y/n: ";;
    esac
done

sudo apt-get update && \
  apt-get install -y automake autoconf libreadline-dev libncurses-dev libssl-dev libyaml-dev libxslt-dev libffi-dev libtool unixodbc-dev curl perl imagemagick openssl openssl-dev ncurses ncurses-dev unixodbc unixodbc-dev git ca-certificates nodejs postgresql-client tzdata openssh-client gawk grep yaml-dev expat-dev libxml2-dev curl make gcc g++ python linux-headers binutils-gold gnupg perl-utils libstdc++

git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.4.3
echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.bashrc
echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc
source ~/.bashrc
mkdir -p $HOME/.asdf/toolset

asdf update --head

asdf plugin-add erlang && \
    asdf plugin-add nodejs && \
    asdf plugin-add elixir

# Adding Erlang/OTP 20.2.4
asdf install erlang 20.2.4

# Adding Elixir 1.6 with corresponding Erlang
asdf install elixir 1.6.3 && \
    asdf global erlang 20.2.4 && \
    asdf global elixir 1.6.3 && \
    yes | mix local.hex --force && \
    yes | mix local.rebar --force

# NodeJS requirements
gpg --keyserver ipv4.pool.sks-keyservers.net --recv-keys 94AE36675C464D64BAFA68DD7434390BDBE9B9C5 && \
    gpg --keyserver ipv4.pool.sks-keyservers.net --recv-keys FD3A5288F042B6850C66B31F09FE44734EB7990E && \
    gpg --keyserver ipv4.pool.sks-keyservers.net --recv-keys 71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 && \
    gpg --keyserver ipv4.pool.sks-keyservers.net --recv-keys DD8F2338BAE7501E3DD5AC78C273792F7D83545D && \
    gpg --keyserver ipv4.pool.sks-keyservers.net --recv-keys C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 && \
    gpg --keyserver ipv4.pool.sks-keyservers.net --recv-keys B9AE9905FFD7803F25714661B63B535A4C206CA9 && \
    gpg --keyserver ipv4.pool.sks-keyservers.net --recv-keys 56730D5401028683275BD23C23EFEFE93C4CFFFE && \
    gpg --keyserver ipv4.pool.sks-keyservers.net --recv-keys 77984A986EBC2AA786BC0F66B01FBB92821C587A

# Adding NodeJS 4.8.7 LTS
asdf install nodejs 4.8.7

# Adding NodeJS 6.13.1 LTS
asdf install nodejs 6.13.1

# Adding NodeJS 8.10.0 LTS
asdf install nodejs 8.10.0

# Setting global versions
asdf global erlang 20.2.4 && \
    asdf global elixir 1.6.3  && \
    asdf global nodejs 8.10.0
