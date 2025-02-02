#!/usr/bin/env bash

cd $(dirname $BASH_SOURCE);

git pull origin main;

function linkDir() {
  mkdir -p ~/.ssh;
	ln -s $PWD/.gitconfig ~/.gitconfig;
	ln -s $PWD/.hushlogin ~/.hushlogin;
	ln -s $PWD/.inputrc ~/.inputrc;
	ln -s $PWD/.screenrc ~/.screenrc;
	ln -s $PWD/.zprofile ~/.zprofile;
	ln -s $PWD/.zshrc ~/.zshrc;	
	ln -s $PWD/.tmux.conf ~/.tmux.conf;
	ln -s $PWD/.tmux.conf.osx ~/.tmux.conf.osx;
	ln -s $PWD/.config/ ~/.config;
	ln -s $PWD/.ssh/config ~/.ssh/config;
}

function runScripts() {
  sudo yes | ./brew.sh;
  sudo yes | ./setup.sh;
  sudo yes | ./macos.sh;
}

function setUp() {
  linkDir;
  runScripts;
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	setUp;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		setUp;
	fi;
fi;
unset doIt;
