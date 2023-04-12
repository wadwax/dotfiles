#!/usr/bin/env bash

cd $(dirname $BASH_SOURCE);

git pull origin main;

function doIt() {
	ln -s $PWD/.gitconfig ~/.gitconfig;
	ln -s $PWD/.hushlogin ~/.hushlogin;
	ln -s $PWD/.inputrc ~/.inputrc;
	ln -s $PWD/.screenrc ~/.screenrc;
	ln -s $PWD/.zprofile ~/.zprofile;
	ln -s $PWD/.zshrc ~/.zshrc;	
	ln -s $PWD/.tmux.conf ~/.tmux.conf;
	ln -s $PWD/.tmux.conf.osx ~/.tmux.conf.osx;
	ln -s $PWD/.config/ ~/.config;
  mkdir -p ~/.ssh;
	ln -s $PWD/.ssh/config ~/.ssh/config;
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
	fi;
fi;
unset doIt;
