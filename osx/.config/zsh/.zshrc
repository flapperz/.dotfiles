unsetopt LIST_BEEP
setopt AUTO_PUSHD

source ~/.config/zsh/lib/history.zsh

# >>> ---- lazy load conda ---
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
# old completion

# autoload -U compinit
# zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
# zstyle ':completion:*' menu select
# zmodload zsh/complist
# # for dump in ${ZDOTDIR}/.zcompdump(N.mh+24); do
# #     compinit
# # done
# # compinit -C
# compinit
# _comp_options+=(globdots)

ADOTDIR=$HOME/.config/zsh/antigens
source $HOME/.config/zsh/antigen.zsh

POWERLEVEL9K_MODE='nerdfont-complete'
THEME=romkatv/powerlevel10k
antigen theme $THEME
source ~/.config/p10k/.p10k.zsh

source <(fzf --zsh)
export FZF_DEFAULT_OPTS="--style minimal"
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --preview '([[ -d {} ]] && eza --tree --color=always {} | head -200) || fzf-preview.sh {}'
  --bind 'focus:transform-header:file --brief {}'"
# CTRL-Y to copy the command into clipboard using pbcopy
export FZF_CTRL_R_OPTS="
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'"
  # --color header:italic
  # --header '^Y: copy command into clipboard'"
# Print tree structure in the preview window
export FZF_ALT_C_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'eza --tree --color=always {} | head -200'"

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza -1 --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo $'{}"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "bat -n --color=always --line-range :500 {}" "$@" ;;
  esac
}

# setopt globdots
### fzf-tab plugin settings
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
# NOTE: don't use escape sequences (like '%F{red}%d%f') here, fzf-tab will ignore them
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'

zstyle ':fzf-tab:*' fzf-bindings 'ctrl-y:toggle'
zstyle ':fzf-tab:*' switch-group '<' '>'

antigen bundle ael-code/zsh-colored-man-pages
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
antigen bundle Aloxaf/fzf-tab
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting # should be last bundle
antigen apply

# options
export LESS="--incsearch --ignore-case --HILITE-UNREAD --status-column --LONG-PROMPT -N"
export BAT_THEME=ansi

source "$ZDOTDIR/alias.sh"

LESSPIPE=`which src-hilite-lesspipe.sh`
alias lessh='LESSOPEN="| ${LESSPIPE} %s" less -r'

# eval "$(fnm env --use-on-cd --shell zsh)"
eval "$(fnm env --shell zsh)"

# postgres
export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/flap/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
