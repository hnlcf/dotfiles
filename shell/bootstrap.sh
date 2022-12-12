# cargo
. "$HOME/.cargo/env"

# fzf
[ -f "$HOME/.fzf.bash" ] && source "$HOME/.fzf.bash"

# nvm
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads NVM_DIR
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# autojump
[[ -s $HOME/.autojump/etc/profile.d/autojump.sh ]] && source $HOME/.autojump/etc/profile.d/autojump.sh

# ghcup -- Ocaml
[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env" # ghcup-env

# conda -- contents within this block are managed by 'conda init' !!
__conda_setup="$('$HOME/Applications/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/Applications/anaconda3/etc/profile.d/conda.sh" ]; then
        . "$HOME/Applications/anaconda3/etc/profile.d/conda.sh"
    else
        path_append "$HOME/Applications/anaconda3/bin"
    fi
fi
unset __conda_setup

# the fuck
eval $(thefuck --alias)


export GOPATH="$HOME/workspace/go"
path_append "$PATH:/usr/local/go/bin"
path_append "$PATH:$GOPATH/bin"

path_prepend "$HOME/.local/bin"
path_prepend "$HOME/.dotfiles/bin"
path_append "$HOME/.local/share/JetBrains/Toolbox/scripts"
path_append "$HOME/.opam/default/bin"

path_append "$HOME/Applications/qemu-5.0.0"
path_append "$HOME/Applications/qemu-5.0.0/riscv64-softmmu"
path_append "$HOME/Applications/qemu-5.0.0/riscv64-linux-user"

path_append "$PATH:/usr/local/texlive/2022/bin/x86_64-linux"
