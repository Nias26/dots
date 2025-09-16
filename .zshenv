# .zshenv file
# Neovim binary file
export NVIM_BIN=/home/Nias/.local/share/bob/nvim-bin/nvim

# PATH
export PATH=$HOME/bin:/usr/local/bin:$HOME/go/bin:$HOME/.cargo/bin/:$HOME/.local/bin/:$HOME/node_modules/.bin/:$NVIM_BIN:$HOME/.scripts/bin/:$PATH

# Dirs
export XDG_DOWNLOAD_DIR=$HOME/Scaricati/
export XDG_DOCUMENTS_DIR=$HOME/Documenti/
export XDG_MUSIC_DIR=$HOME/Musica/
export XDG_PICTURES_DIR=$HOME/Immagini
export XDG_VIDEOS_DIR=$HOME/Video/

# You may need to manually set your language environment
export LANG=it_IT.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
	export EDITOR=$NVIM_BIN
else
	export EDITOR=vim
fi

# Diffprog
export DIFFPROG="$NVIM_BIN -d $@"

# Manpager
#export MANPAGER='nvim +Man!'  # Nvim as manpager
export MANROFFOPT='-c'
export MANPAGER="sh -c 'col -bx | bat -l man -p'" # Bat as manpager

# Git credential store
export GCM_CREDENTIAL_STORE=gpg

# Sudo prompt
# $(tput setaf <colour>)<text>$(tput sgr0)
export SUDO_PROMPT=" $(tput setaf 6)[sudo] $(tput setaf sgr0)- $(tput setaf 1)%p$(tput setaf 8)@$(tput setaf 3)%h$(tput setaf 8): $(tput sgr0)"
export SUDO_ASKPASS=/usr/bin/ksshaskpass

# Firefox on wayland
if [[ $XDG_SESSION_TYPE = "wayland" ]]; then
	export MOZ_ENABLE_WAYLAND=1
fi

# zoxide
export _ZO_ECHO=0
export _ZO_FZF_OPTS="--ansi --preview='exa -1 --color=always $realpath'"
export _ZO_RESOLVE_SYMLINKS=1
# export _ZO_EXCLUDE_DIRS=$HOME:$HOME/private/*:/path/to/dir
