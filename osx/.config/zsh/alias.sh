alias tms="tmux-sessionizer"
alias vim="nvim"

alias cdsrc="cd ~/Source"
alias cdmn="cd ~/Minervia"

alias cdback="cd ~/Minervia/RSAPP/RSAPP-backend"
alias cdbackback="cd ~/Minervia/RSAPP/RSAPP-backend/backend"
alias cdfront="cd ~/Minervia/RSAPP/RSAPP-frontend-new"
alias cdleg="cd ~/Minervia/RSAPP/rsapp-legacy"

alias cdconf="cd ~/.dotfiles/osx/.config"

alias ls='ls --color=auto -F'
alias ll='ls -alF'
alias la='ls -A'

alias gg='git-graph'
alias ggmk='python /Users/flap/Source/git-magik/git-magik.py'

# python
alias act="conda activate"
alias venv="source .venv/bin/activate"

finder() {
    open .
}
zle -N finder
bindkey '^f' finder
