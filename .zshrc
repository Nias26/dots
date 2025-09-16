# .zshrc File
zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' frequency 13

# Oh-My-Zsh
export ZSH="$HOME/.oh-my-zsh"

# Completion waiting dots
COMPLETION_WAITING_DOTS=" %F{yellow}loading %F{red}.%F{green}.%F{blue}.%f"

# zsh-tmux config
# ZSH_TMUX_AUTOSTART_ONCE=true
# ZSH_TMUX_AUTOCONNECT=false
# ZSH_TMUX_AUTOQUIT=true
# ZSH_TMUX_FIXTERM=true

# Theme settings
# ZSH_THEME="headline"
eval "$(starship init zsh)"

# Plugins
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  fzf
  fzf-tab
  zsh-autosuggestions
  zsh-syntax-highlighting
)

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
zstyle ':fzf-tab:*' fzf-bindings 'alt-q:toggle'
#Show dotfiles
setopt globdots
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# preview directory's content with exa when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
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


# Source Oh-My-Zsh
source $ZSH/oh-my-zsh.sh

# User configuration
for f in ~/.scripts/*.zsh; do
	source $f
done

# Aliases
alias cat='bat -p --wrap=never --color=always'
alias ip='ip --color=auto'
alias ls='eza --group-directories-first --icons=always'
alias l='eza -lag --group-directories-first --icons=always'
alias ll='eza -l --group-directories-first --icons=always'
alias la='eza -la --group-directories-first --icons=always'
alias lt='eza --tree --group-directories-first --icons=always'
alias pacman='sudo pacman'
alias pipes='pipes.sh -p 3 -r 10000 -R'
alias :q='tmux detach'
alias exi='if [[ $(tmux list-windows | wc -l) > 1 ]]; then tmux kill-window; else tmux detach; fi'
alias clear='clear && shell-color'
alias 'pacman -R'='pacman -Rns'
alias rmf='rm -rf'
alias catt='/usr/bin/cat'
alias man='mancho.sh'
alias tree='exa -1 -L 1 --color=always -T --icons -a'
alias s='sudo'
alias lg='lazygit'
alias xcopy='xclip -selection clipboard'
alias wcopy='wl-copy'
alias t='touch'
# alias dmesg='sudo dmesg -wH --color=always'
alias checkpkg="pacman -Qkk"
alias downgrade="sudo downgrade"
alias neofetch="fastfetch"
alias open="xdg-open"
alias cmake_gen="cmake -B./build -S./"

# Set Personal Bindkeys
bindkey "^[[1~" beginning-of-line # HOME
bindkey "^[[4~" end-of-line       # END
bindkey "^[[3~" delete-char       # DEL
bindkey -s "^[l" "clear\n"  # Clear screen (really useful)

# Theme Settings
HEADLINE_TRUNC_PREFIX='…'

HEADLINE_DO_GIT_STATUS_COUNTS=true

# Separator options
HEADLINE_LINE_MODE=auto # on|auto|off (whether to print the line above the prompt)

# Prompt
HEADLINE_PROMPT='%F{blue}:: %F{yellow}' #'%(#.#.%(!.!.$)) ' # consider "%#"
HEADLINE_RPROMPT=''

# Clock (prepends to RPROMPT)
HEADLINE_DO_CLOCK=true
# TMOUT=1; TRAPALRM () { zle reset-prompt } # Uncomment for continous clock

# Error code details
HL_ERR_MODE=detail
HL_INFO_MODE=auto

# zoxide
eval "$(zoxide init zsh)"
alias cd='z'
alias cdi='zi'

# Tmux
# INFO:Attach to an detached session and if not create one
tmux attach -t $(sess=$(tmux ls -F '#{session_name}|#{?session_attached,attached,not attached}' 2> /dev/null | \
	grep 'not attached$' | \
	tail -n 1 | \
	cut -d '|' -f1) 2> /dev/null;	echo ${sess}) 2>/dev/null || tmux new-session &>/dev/null
# INFO:If not in tmux session, exit
if [[ -z $TMUX ]]; then
	exit
fi

# Keychain (ssh)
eval $(keychain --eval --quiet Github)
