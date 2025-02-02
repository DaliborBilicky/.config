# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

export STARSHIP_CONFIG=~/.config/starship/starship.toml
export EDITOR="nvim"
export TERMINAL="kitty"

alias vim='nvim'
alias vi='nvim'
alias cc='clear'
alias ls='lsd -a --group-directories-first'
alias ll='lsd -al --group-directories-first'
alias lll='lsd -al --group-directories-first --blocks permission,user,group,size,date,name'

test -s ~/.alias && . ~/.alias || true
eval "$(zoxide init bash)"
eval "$(starship init bash)"
