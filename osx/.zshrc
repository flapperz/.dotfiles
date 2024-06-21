fpath=( "$HOME/.config/zsh/zfunctions" $fpath )
# autoload -U promptinit && promptinit
autoload -Uz prompt_purification_setup && prompt_purification_setup
# prompt flap

path=("$HOME/.local/bin" $PATH)
export PATH

# disable beeb before tab suggestion
unsetopt LIST_BEEP

# >>> ---- nvm lazy load ----
export NVM_DIR="$HOME/.nvm"
        [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion
export PATH="$NVM_DIR/versions/node/v$(<$NVM_DIR/alias/default)/bin:$PATH"
# alias `nvm` to this one liner lazy load of the normal nvm script
alias nvm="unalias nvm; [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"; nvm $@"
# <<< ---- nvm lazy load ----



# ----------
# fzf config
# ----------

# -------
# aliases
# -------

# syntax highlight less
LESSPIPE=`which src-hilite-lesspipe.sh`
alias lessh='LESSOPEN="| ${LESSPIPE} %s" less -r'

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

export BAT_THEME=ansi