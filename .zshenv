# .zshenv file
# Neovim binary file
export NVIM_BIN=/home/Nias/.local/share/bob/nvim-bin/nvim

# PATH
export PATH=$HOME/bin:/usr/local/bin:$HOME/.config/nvim/bin/:$HOME/go/bin:$HOME/.cargo/bin/:$HOME/.local/bin/:$HOME/node_modules/.bin/:$HOME/.local/share/bob/nvim-bin:$HOME/.scripts/bin:$PATH

# Dirs
export XDG_DOWNLOAD_DIR=$HOME/Scaricati/
export XDG_DOCUMENTS_DIR=$HOME/Documenti/
export XDG_MUSIC_DIR=$HOME/Musica/
export XDG_PICTURES_DIR=$HOME/Foto/
export XDG_VIDEOS_DIR=$HOME/Video/

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
	export EDITOR=nvim
else
	export EDITOR=nvim
fi

# Manpager
#export MANPAGER='nvim +Man!'  # Nvim as manpager
export MANROFFOPT='-c'
export MANPAGER="sh -c 'col -bx | bat -l man -p'" # Bat as manpager

# Git creddentials
export GCM_CREDENTIAL_STORE=gpg

# Sudo prompt
# $(tput setaf <colour>)<text>$(tput sgr0)
export SUDO_PROMPT=" $(tput setaf 6)[sudo] $(tput setaf sgr0)- $(tput setaf 1)%h$(tput setaf 0):$(tput setaf 3)%p: $(tput sgr0)"
export SUDO_ASKPASS=/usr/bin/ksshaskpass

# Firefox on wayland
if [[ $XDG_SESSION_TYPE = "wayland" ]]; then
	export MOZ_ENABLE_WAYLAND=1
fi

# Git Credentail Manager (GCM)
export GCM_CREDENTIAL_STORE=secretservice

