#!/usr/bin/zsh
# TODO: Implement dev-env command for developing utilities

function dev-env(){
  # Git
  export GIT_N="git@Nias26.github.com"
  export GIT_HS="git@Hlv-Std.github.com"

  # Luarocks
  # NOTE: As of lua 5.5 luarocks is broken
  # eval "$(luarocks path --bin)"
}


