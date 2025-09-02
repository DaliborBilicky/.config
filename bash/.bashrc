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
export FZF_DEFAULT_OPTS='
	--prompt="ƒ: " --pointer="➜" --marker="+"
	--layout=reverse --height=40% --border
	--color=fg:#ebdbb2,bg:#282828
	--color=fg+:#b8bb26,bg+:#282828
	--color=hl:#fe8019,hl+:#fe8019
	--color=info:#bdae93,header:#ebdbb2
	--color=prompt:#bdae93,pointer:#bdae93
	--color=marker:#fabd2f,spinner:#d3869b
	--bind=alt-k:up,alt-j:down'

alias vim='nvim'
alias vi='nvim'
alias cc='clear'
alias ls='lsd -a --group-directories-first'
alias ll='lsd -al --group-directories-first'
alias lll='lsd -al --group-directories-first --blocks permission,user,group,size,date,name'

test -s ~/.alias && . ~/.alias || true
eval "$(starship init bash)"
export _ZO_DOCTOR=0
eval "$(zoxide init bash)"
