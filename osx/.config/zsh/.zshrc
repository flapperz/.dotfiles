unsetopt LIST_BEEP
setopt AUTO_PUSHD

source ~/.config/zsh/lib/history.zsh

# >>> ---- nvm lazy load ----
export NVM_DIR="$HOME/.nvm"
        [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion
export PATH="$NVM_DIR/versions/node/v$(<$NVM_DIR/alias/default)/bin:$PATH"
# alias `nvm` to this one liner lazy load of the normal nvm script
alias nvm="unalias nvm; [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"; nvm $@"
# <<< ---- nvm lazy load ----

# >>> ---- lazy load conda ----
# https://www.reddit.com/r/zsh/comments/qmd25q/lazy_loading_conda/
# Add any commands which depend on conda here
lazy_conda_aliases=('python' 'conda')

load_conda() {
  for lazy_conda_alias in $lazy_conda_aliases
  do
    unalias $lazy_conda_alias
  done

  __conda_prefix="$HOME/miniconda3" # Set your conda Location

  # >>> conda initialize >>>
  __conda_setup="$("$__conda_prefix/bin/conda" 'shell.bash' 'hook' 2> /dev/null)"
  if [ $? -eq 0 ]; then
      eval "$__conda_setup"
  else
      if [ -f "$__conda_prefix/etc/profile.d/conda.sh" ]; then
          . "$__conda_prefix/etc/profile.d/conda.sh"
      else
          export PATH="$__conda_prefix/bin:$PATH"
      fi
  fi
  unset __conda_setup
  # <<< conda initialize <<<

  unset __conda_prefix
  unfunction load_conda
}

for lazy_conda_alias in $lazy_conda_aliases
do
  alias $lazy_conda_alias="load_conda && $lazy_conda_alias"
done
# <<< ---- lazy load conda ----

# this add 0.02 s.
autoload -U compinit
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu select
zmodload zsh/complist
# for dump in ${ZDOTDIR}/.zcompdump(N.mh+24); do
#     compinit
# done
# compinit -C
compinit
_comp_options+=(globdots)

ADOTDIR=$HOME/.config/zsh/antigens
source $HOME/.config/zsh/antigen.zsh

POWERLEVEL9K_MODE='nerdfont-complete'
THEME=romkatv/powerlevel10k
antigen theme $THEME
source ~/.config/p10k/.p10k.zsh

source <(fzf --zsh)
# Preview file content using bat (https://github.com/sharkdp/bat)
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo $'{}"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "bat -n --color=always --line-range :500 {}" "$@" ;;
  esac
}

antigen bundle ael-code/zsh-colored-man-pages
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting # should be last bundle
antigen apply

# options
export LESS="--incsearch --ignore-case --HILITE-UNREAD --status-column --LONG-PROMPT -N"
export BAT_THEME=ansi

# aliases
alias ls='ls --color=auto'
alias cdsrc="cd ~/Source"
alias cdgrf="cd ~/Graffity"

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias gg='git-graph'
alias gga='git add'
alias ggc='git commit'
alias ggmk='python /Users/flap/Source/git-magik/git-magik.py'

alias pn='pnpm'

alias act="conda activate"

# alias ls="eza --oneline --git --icons=auto --color=auto"

LESSPIPE=`which src-hilite-lesspipe.sh`
alias lessh='LESSOPEN="| ${LESSPIPE} %s" less -r'

# eval "$(fnm env --use-on-cd --shell zsh)"
eval "$(fnm env --shell zsh)"

# postgres
export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"
