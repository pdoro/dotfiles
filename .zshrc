
#========================================================
#================ ZSHRC CONFIGURATION ==================
#========================================================

### Make $PATH a set, no repeated values ###
typeset -U path

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

ZSH_THEME="prose"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=15

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(git colorize zsh-syntax-highlighting mvn zsh-completions solarized-man docker docker-compose)

source $ZSH/oh-my-zsh.sh

# User configuration
EDITOR='nvim'

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# UTF-8 character encoding
export LANG=es_ES.UTF-8
export LC_ALL=es_ES.UTF-8
export LANGUAGE=es_ES.UTF-8
export LESSCHARSET=utf-8

# Less options
export PAGER=less
export LESS=-R
export LESSOPEN='|~/.config/lessfilter %s'
export LESSOPEN='|~/.config/lessfilter %s'

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='vim'
fi

## https://unix.stackexchange.com/a/62599
path=(/opt/robo3t-1.1.1/bin "$path[@]")

alias edit_zshrc="$EDITOR ~/.zshrc"
alias reload_zshrc="source ~/.zshrc"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#### Enhancd ####
source $ZSH/custom/enhancd/init.sh

#### alias ####
alias ls="exa -@ghHSlUma --group-directories-first -s extension"
#alias ls="ls -laHG --color"
alias clc="clear"
alias java_versions="sudo update-alternatives --config java"

export JAVA_HOME="/usr/lib/jvm/java-8-oracle"

########## ZSH prompt ##########
export DEFAULT_USER='pdomingo'

prompt_context() {
  # https://github.com/agnoster/agnoster-zsh-theme/issues/39
  if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    prompt_segment black default "%(!.%{%F{yellow}%}.)$USER"
  fi
}
################################

#### https://github.com/nvbn/thefuck #####
eval "$(thefuck --alias)"

#### TMUX conditional execution ####
if [ "$TMUX" = "" ]; 
    then tmux; 
fi 

# fh - repeat history
fh() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf --tac | sed 's/ *[0-9]* *//')
}

alias history="fh"
alias his="fh"
alias please='sudo $(fc -ln -1)' # Execute last command as sudo
alias finddir='print -z $(find . -type d | fzf)'
alias findfile='print -z $(find . -type f | fzf)'

export PAGER="less -SF"

#######################################

zstyle ':completion:*' menu yes select

# Format all messages not formatted in bold prefixed with ----
zstyle ':completion:*'                 format $'\n%B[---- %d%b ----]'
# Format descriptions (notice the vt100 escapes)
zstyle ':completion:*:descriptions'    format $'\n%{\e[0;31m%}completing %B%d%b%{\e[0m%}'
# Format bold and underline normal messages
zstyle ':completion:*:messages'        format $'\n%B%U[---- %d%u%b ----]'
# Format in bold red error messages
zstyle ':completion:*:warnings'        format "%B$fg[red]%}[---- no match for: $fg[white]%d%b $fg[red]----]"
# Let's use the tag name as group name
zstyle ':completion:*' group-name ''

# Docker autocompletion
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes


autoload -U compinit && compinit
_comp_options+=(globdots)
export FZF_DEFAULT_OPTS='--height 87% --reverse --border'

export LESS='-RMs'
export LESSOPEN='|~/.lessfilter %s'

alias dc='docker-compose'
alias dcps='docker-compose ps'
alias dps='docker ps'
alias dex='docker exec'
alias drun='docker run'
alias git-graph='git log --graph --all --decorate --branches=master'

