# Functions
source ~/.shell/functions.sh

# Allow local customizations in the ~/.shell_local_before file
if [ -f ~/.shell_local_before ]; then
    source ~/.shell_local_before
fi

# Allow local customizations in the ~/.zshrc_local_before file
if [ -f ~/.zshrc_local_before ]; then
    source ~/.zshrc_local_before
fi

# External plugins (initialized before)
source ~/.zsh/plugins_before.zsh

# Settings
source ~/.zsh/settings.zsh

# Custom prompt
# source ~/.zsh/prompt.zsh   # Replace with starship prompt in `~/.zshrc_local_after`

# External plugins (initialized after)
source ~/.zsh/plugins_after.zsh

# Bootstrap
source ~/.shell/bootstrap.sh

# External settings
source ~/.shell/external.sh

# Aliases
source ~/.shell/aliases.sh

# language enviroment
source ~/.shell/language.sh

# auto commands
source ~/.shell/autocommands.sh

# fzy configs
source ~/.shell/fzf-completion.zsh
source ~/.shell/fzf-key-bindings.zsh


# Allow local customizations in the ~/.shell_local_after file
if [ -f ~/.shell_local_after ]; then
    source ~/.shell_local_after
fi

# Allow local customizations in the ~/.zshrc_local_after file
if [ -f ~/.zshrc_local_after ]; then
    source ~/.zshrc_local_after
fi

# Allow private customizations (not checked in to version control)
if [ -f ~/.shell_private ]; then
    source ~/.shell_private
fi

