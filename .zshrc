# Tmux
# Attach to a detached session and if not create one
if [ -z "$TMUX" ]; then
    session=$(tmux list-sessions -F '#{session_name} #{session_attached}' 2>/dev/null | awk '$2 == 0 { print $1; exit }')

    if [ -n "$session" ]; then
        exec tmux attach -t "$session"
    else
        exec tmux new-session
    fi
fi

# update automatically without asking
zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 13

# Oh-My-Zsh
export ZSH="$HOME/.oh-my-zsh"

# Completion waiting dots
COMPLETION_WAITING_DOTS=" %F{yellow}loading %F{red}.%F{green}.%F{blue}.%f"

# Theme settings
ZSH_THEME="headline"
# eval "$(starship init zsh)"

# Plugins
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  fzf
  fzf-tab
  zsh-autosuggestions
  zsh-syntax-highlighting
  # zsh-vi-mode
)

source $ZSH/oh-my-zsh.sh

# Plugins Configs
# fzf-tab
export FZF_DEFAULT_OPTS="--ansi"
FZF_TAB_GROUP_COLORS=(
  $'\033[94m' $'\033[32m' $'\033[33m' $'\033[35m' $'\033[31m' $'\033[38;5;27m' $'\033[36m' \
    $'\033[38;5;100m' $'\033[38;5;98m' $'\033[91m' $'\033[38;5;80m' $'\033[92m' \
    $'\033[38;5;214m' $'\033[38;5;165m' $'\033[38;5;124m' $'\033[38;5;120m'
  )
  zstyle ':fzf-tab:*' group-colors $FZF_TAB_GROUP_COLORS
  # Change keybinds
  zstyle ':fzf-tab:*' fzf-bindings 'tab:down' 'shift-tab:up' 'alt-q:toggle+down' 'ctrl-d:preview-down' 'ctrl-u:preview-up'
  #Show dotfiles
  setopt globdots
  # disable sort when completing `git checkout`
  zstyle ':completion:*:git-checkout:*' sort false
  # set descriptions format to enable group support
  zstyle ':completion:*:descriptions' format '[%d]'
  # set list-colors to enable filename colorizing
  zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
  # preview directory's content with eza when completing cd
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 $realpath -a --icons=auto'
  # switch group using `,` and `.`
  zstyle ':fzf-tab:*' switch-group ',' '.'
  # give a preview of commandline arguments when completing `kill`
  zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
  zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview \
    '[[ $group == "[process ID]" ]] && ps --pid=$word -o cmd --no-headers -w -w'
  zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap
  zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'
  zstyle ':fzf-tab:complete:*:*' fzf-preview 'less ${(Q)realpath}'
  export LESSOPEN='|~/.lessfilter %s'
  export LESS="-R"
  zstyle ':fzf-tab:complete:*:options' fzf-preview
  zstyle ':fzf-tab:complete:*:argument-1' fzf-preview
  zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' \
    fzf-preview 'echo ${(P)word}'
  # it is an example. you can change it
  zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview \
    'git diff $word | delta'
  zstyle ':fzf-tab:complete:git-log:*' fzf-preview \
    'git log --color=always $word'
  zstyle ':fzf-tab:complete:git-help:*' fzf-preview \
    'git help $word | bat -plman --color=always'
  zstyle ':fzf-tab:complete:git-show:*' fzf-preview \
    'case "$group" in
  "commit tag") git show --color=always $word ;;
  *) git show --color=always $word | delta ;;
esac'
zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview \
  'case "$group" in
"modified file") git diff $word | delta ;;
"recent commit object name") git show --color=always $word | delta ;;
*) git log --color=always $word ;;
esac'
zstyle ':fzf-tab:complete:-command-:*' fzf-preview \
  '(out=$(tldr --color always "$word") 2>/dev/null && echo $out) || (out=$(MANWIDTH=$FZF_PREVIEW_COLUMNS man "$word") 2>/dev/null && echo $out) || (out=$(which "$word") && echo $out) || echo "${(P)word}"'

# zsh-autosuggestions
bindkey -r "^Y"
bindkey "^Y" autosuggest-accept

# User configuration
for f in ~/.scripts/*.zsh; do
  source $f
done

# Aliases
alias cat="bat -p --wrap never"
alias less="bat -p --wrap never"
alias scat="/usr/bin/cat"
alias sless="/usr/bin/less"
alias ip="ip --color=auto"
alias ls="eza --group-directories-first --icons=auto"
alias l="eza -lag --group-directories-first --icons=auto"
alias ll="eza -l --group-directories-first --icons=auto"
alias la="eza -la --group-directories-first --icons=auto"
alias lt="eza --tree --group-directories-first --icons=auto"
alias pipes="pipes -p 3 -r 10000 -R"
alias :q="tmux detach"
alias exi="tmux detach"
alias clear="clear && shell-color"
alias rmf="rm -rf"
alias man="mans"
alias tree="eza -1 -L 1 --color=always -T -a --icons=auto"
alias s="sudo"
alias lg="lazygit"
alias xcopy="xclip -selection clipboard"
alias dmesg="sudo dmesg -H --color=always"
# alias checkpkg="pacman -Qkk"
alias venv="source .venv/bin/activate"
# alias check_duplicates="find . -type f -exec md5sum {} + | sort | uniq -w32 -dD"
alias meteo="curl -sS v2d.wttr.in/\$(curl -sS ipinfo.io/json | jq -r '.loc')"
alias lsblk="lsblk -o NAME,MAJ:MIN,RM,SIZE,RO,TYPE,FSTYPE,MOUNTPOINTS "

# Set Personal Bindkeys
bindkey "^[[1~" beginning-of-line # HOME
bindkey "^[[4~" end-of-line       # END
bindkey "^[[3~" delete-char       # DEL
bindkey '^P' up-line-or-beginning-search
bindkey '^N' down-line-or-beginning-search

# Theme Settings
HL_GIT_COUNT_MODE='auto'
HL_PROMPT='%{$black%}╰%{$yellow%}λ '
HL_GIT_SEP_SYMBOL='|'
HL_LAYOUT_TEMPLATE[_PRE]='%{$reset_color%}%{$black%}╭'
HL_SEP_MODE='off'
# HL_CLOCK_MODE='on'
# HL_ERR_MODE='detail'
# TMOUT=1; TRAPALRM () { zle reset-prompt } # Uncomment for continous clock

# zoxide
eval "$(zoxide init zsh)"
alias cd='z'
alias cdi='zi'

# Keychain (ssh)
eval "$(keychain add Github-Nias26 Github-Hlv-Std --eval --immediate --quiet)"
