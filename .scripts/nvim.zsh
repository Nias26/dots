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

function nyoom(){
	NVIM_APPNAME=nyoom $NVIM_BIN $@
}

function chad(){
  NVIM_APPNAME=NvChad $NVIM_BIN $@
}

alias nvim='NVIM_APPNAME=default $NVIM_BIN'
alias vi='/usr/bin/vim'
