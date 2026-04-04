#!/usr/bin/zsh

# Git
export GIT_USER="Nias26"

function gch(){
  local accounts=("Nias26" "Helvetica Standard")
  local choice=$(gum choose --header="Select the Git user:" "${accounts[@]}")
  case "$choice" in
    "Nias26")
      git config user.name "Nias26"
      git config user.email "genangeliludovico26@gmail.com"
      if [[ $? != 0 ]]; then
        return 1;
      fi
      GIT_USER=Nias26
      ;;
    "Helvetica Standard")
      git config user.name "Helvetica Standard"
      git config user.email "genangeliludovico26+helvetica@gmail.com"
      if [[ $? != 0 ]]; then
        return 1;
      fi
      GIT_USER=Hlv-Std
      ;;
    *)
      return 1
      ;;
  esac
}

# Luarocks
eval "$(luarocks path --bin)"
