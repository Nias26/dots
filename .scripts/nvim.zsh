#!/usr/bin/zsh

function vim(){
    NVIM_APPNAME=nvim $NVIM_BIN $@
}

function svim(){
	sudo -e $@
}

function m(){
    NVIM_APPNAME=mini $NVIM_BIN $@
}

alias nvim="${NVIM_BIN}"
alias vi='/usr/bin/vim'
