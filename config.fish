###
### Functions related to proxy operation
###

function conn_proxy -d "Connect proxy with pigchacli"
  pigchacli --status
  sudo pigchacli
end

function my_proxy -d "Set proxy for person."
  set_proxy "http://127.0.0.1:15777"
  echo "-- Person proxy on"
end

function wk_proxy -d "Set proxy for work."
  set_proxy "socks5://127.0.0.1:1089"
  echo "-- Work proxy on"
end

function set_proxy -d "Set new proxy."
  noproxy
  set --global --export http_proxy $argv
  set --global --export https_proxy $argv
  git config --global http.proxy $argv
  git config --global https.proxy $argv
  echo "-- Set proxy" $argv
end

function noproxy -d "Unset old proxy."
  set --erase http_proxy
  set --erase https_proxy
  git config --global --unset http.proxy
  git config --global --unset https.proxy
  echo "-- Erase old proxy."
end

###
### Environment varibales
###

# Set person proxy when init
set --global --export http_proxy "127.0.0.1:15777"
set --global --export https_proxy "127.0.0.1:15777"

# Set other envs
set --global --export TERM xterm-256color
set --global --export EDITOR nvim
set --global --export TERMINAL alacritty
set --global --export KERL_BUILD_DOCS "yes"
# set --global --export KDEWM "$HOME/.cabal/bin/xmonad"
set --global --export NVM_DIR "$HOME/.nvm"

set --global --export GOPROXY https://goproxy.cn
set --global --export GOPATH "$HOME/workspace/go/package"

# Set China mirror of Elixir mix
set --global --export HEX_MIRROR "https://hexpm.upyun.com"
set --global --export HEX_CDN "https://hexpm.upyun.com"

###
### Command aliases
###

alias wl='~/workspace'
alias j='ranger'
alias vi='nvim'
alias hx='helix'
alias zj='zellij'
alias sl="subl"
alias sm="smerge"
alias cl='clear'
alias gl="git clone"
alias l="exa --all --long --icons --group-directories-first"
alias ls="exa --icons --group-directories-first"
alias ll="exa --long --icons --group-directories-first"
alias la="exa --all --long --icons --group-directories-first"
alias bat="bat --style=full --theme=OneHalfDark"
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'


###
### Applications bootstrap
###

# Anaconda conda
# eval /home/changfeng/Applications/anaconda3/bin/conda "shell.fish" "hook" $argv | source

# OCaml opam
source /home/changfeng/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true

# Prompt starship
starship init fish | source

###
### Interactive mode
###

if status is-interactive
    # Commands to run in interactive sessions can go here
end

