export EDITOR=nvim

# Http proxy
export http_proxy="http://127.0.0.1:15777"
export https_proxy="http://127.0.0.1:15777"

# pip should only run if there is a virtualenv currently activated
export PIP_REQUIRE_VIRTUALENV=true

# Cache pip-installed packages to avoid re-downloading
export PIP_DOWNLOAD_CACHE=$HOME/.pip/cache

# Python startup file
export PYTHONSTARTUP=$HOME/.pythonrc

# nvm mirror in China
export NVM_NODEJS_ORG_MIRROR="http://npm.taobao.org/mirrors/node"

# debuginfod for Valgrind
export DEBUGINFOD_URLS="https://debuginfod.archlinux.org"

# Vagrant
VAGRANT_DISABLE_VBOXSYMLINKCREATE=1
