# .zshenv - sourced for all shells

############################################################
# https://kev.inburke.com/kevin/profiling-zsh-startup-time/
PROFILE_STARTUP=false
if [[ "$PROFILE_STARTUP" == true ]]; then
    # http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
    PS4=$'%D{%M%S%.} %N:%i> '
    exec 3>&2 2>$HOME/tmp/startlog.$$
    setopt xtrace prompt_subst
fi
############################################################

WORDCHARS=''
HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

skip_global_compinit=1
unsetopt menu_complete   # do not autoselect the first completion entry
unsetopt flowcontrol
setopt auto_menu         # show completion menu on succesive tab press
setopt complete_in_word
setopt always_to_end

setopt hist_ignore_dups # ignore duplication command history list
setopt share_history # share command history data

setopt inc_append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_space

setopt SHARE_HISTORY
setopt APPEND_HISTORY

zstyle ':completion:*:*:git:*' script $(brew --prefix)/etc/bash_completion.d/git-completion.bash

autoload -U compinit
compinit -i

########################## prompt ##########################
autoload colors; colors;
setopt prompt_subst

function git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "$(parse_git_dirty)(${ref#refs/heads/})%{$reset_color%}"
}

parse_git_dirty () {
  if [[ -n $(git status -s 2> /dev/null) ]]; then
    echo "%{$fg[red]%}" # dirty
  else
    echo "%{$fg[green]%}" # clean
  fi
}

PROMPT='%{$fg[magenta]%}[%c]%{$reset_color%} '
RPROMPT='%{$fg[blue]%}${AWS_VAULT}%{$reset_color%} %{$fg[magenta]%}$(git_prompt_info)%{$reset_color%}'
############################################################

export PATH=$HOME/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin
export PATH=$PATH:/usr/local/share/npm/bin
export PATH=$PATH:$HOME/.cargo/bin

export GOPATH=$HOME/code
export PATH=$PATH:$GOPATH/bin

export EDITOR=vim
export PAGER=less
export LC_CTYPE=en_US.UTF-8

export GREP_OPTIONS='--color=auto'
export GREP_COLOR='1;32'

export FZF_DEFAULT_COMMAND='ag -l -g ""'

export LOG_FORMAT=colored
export LOG_LEVEL=debug

## smart urls
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

## zmv is awesome
autoload -U zmv
alias mmv='noglob zmv -W'

## always use emacs style keybinds
bindkey -e

# Enable Ctrl-x-e to edit command line
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

export BREW_PREFIX=$(brew --prefix)

# autojump
[[ -s $BREW_PREFIX/etc/autojump.sh ]] && . $BREW_PREFIX/etc/autojump.sh

BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"

export AWS_DEFAULT_REGION=us-east-1
export AWS_REGION=$AWS_DEFAULT_REGION
[[ -s $BREW_PREFIX/bin/aws_zsh_completer.sh ]] && . $BREW_PREFIX/bin/aws_zsh_completer.sh

[[ -s /usr/local/bin/env_parallel.zsh ]] && . /usr/local/bin/env_parallel.zsh

######################################################
for config_file ($HOME/.zsh/*.zsh) source $config_file
######################################################

if [[ "$PROFILE_STARTUP" == true ]]; then
    unsetopt xtrace
    exec 2>&3 3>&-
fi
