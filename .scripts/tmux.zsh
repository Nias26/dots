#!/usr/bin/zsh

function fzf-tmux-sessions () {
    tmux ls -F '#{session_name} [#{window_name}] | #{?session_attached,󰁦 attached,󱫃 not attached}' | \
    fzf --tmux center \
    --preview-window=up:70% \
    --preview 'tmux capture-pane -ept $(echo {} | cut -d" " -f1)' | \
    sed 's/ .*//' |
    xargs tmux switchc -t
}
bindkey -s "^[s" "fzf-tmux-sessions\n"


