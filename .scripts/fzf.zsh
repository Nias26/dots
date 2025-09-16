#!/usr/bin/zsh

# AUR Helper
# Install packages
function in() {
    paru -Slq | fzf -q "$1" -m --preview 'paru -Si {1}'| xargs -ro paru -S --needed
}
bindkey -s "^[i" "in\n"

# Remove installed packages
function re() {
    paru -Qq | fzf -q "$1" -m --preview 'paru -Qi {1}' | xargs -ro paru -Rns
}
bindkey -s "^[r" "re\n"

# yt-dlp
function ytd(){
	choice=$(gum choose "Audio Download" "Audio Playlist Download" "Video Download" "Video Playlist Download" --cursor="* ")
	case "$choice" in
		"Audio Download")
			URL=$(gum input --placeholder="Insert video URL")
			yt-dlp --no-part -x --audio-format mp3 -o "%(title)s.%(ext)s" $URL
			;;
		"Audio Playlist Download")
			URL=$(gum input --placeholder="Insert playlist URL")
			yt-dlp --no-part -x --yes-playlist --audio-format mp3 -o "%(title)s.%(ext)s" $URL
			;;
		"Video Download")
			URL=$(gum input --placeholder="Insert video URL")
			yt-dlp -S "height:1080" $URL
			;;
		"Video Playlist Download")
			URL=$(gum input --placeholder="Insert playlist URL")
			yt-dlp --no-part -S "height:1080" --yes-playlist --playlist-items 1-100 --output "%(playlist_index)s-%(title)s.%(ext)s" $URL
			;;
	esac
}

# tmux
function fzf-tmux-sessions(){
  tmux ls -F'#{session_name} [#{window_name}] | #{?session_attached,󰁦 attached,󱫃 not attached}' |
  fzf --tmux center \
  --preview-window=up:70% \
  --preview 'tmux list-windows -t $(echo {} | sed "s/ .*//" ) -F "  Window: #I - #W - active pane: #{pane_current_command}"' |
  sed 's/ .*//' |
  xargs tmux switchc -t 
}
bindkey -s "^[s" "fzf-tmux-sessions\n"

