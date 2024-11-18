#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# zmodload zsh/zprof

# Load macgnu
test -f "$HOME/.macgnu" && source "$HOME/.macgnu"

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...
# ====================================================================
# ZSH options
# ====================================================================
unsetopt CORRECT # Disable autocorrect guesses. Happens when typing a wrong
unsetopt NOMATCH # Disable error printing when a pattern is not matched
# command that may look like an existing one.
expand-or-complete-with-dots() { # This bunch of code displays red dots when autocompleting
  echo -n "\e[31m......\e[0m"    # a command with the tab key, "Oh-my-zsh"-style.
  zle expand-or-complete
  zle redisplay
}
zle -N expand-or-complete-with-dots
bindkey "^I" expand-or-complete-with-dots

# Enable Ctrl-x-e to edit command line
autoload -U edit-command-line
# Emacs style
# zle -N edit-command-line
# bindkey '^xe' edit-command-line
# bindkey '^x^e' edit-command-line
# Vi style:
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# # csvtk autocompletion
fpath=(~/.zfunc "${fpath[@]}")
autoload -U compinit
compinit

# Custom config
test -f "$HOME/.customrc.sh" && source "$HOME/.customrc.sh"
test -f "$CONFIG_SCRIPTS_DIR/config.history.zsh" && source "$CONFIG_SCRIPTS_DIR/config.history.zsh"

# zprof



# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/canolab_13/.software/miniforge/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/canolab_13/.software/miniforge/etc/profile.d/conda.sh" ]; then
        . "/Users/canolab_13/.software/miniforge/etc/profile.d/conda.sh"
    else
        export PATH="/Users/canolab_13/.software/miniforge/bin:$PATH"
    fi
fi
unset __conda_setup

if [ -f "/Users/canolab_13/.software/miniforge/etc/profile.d/mamba.sh" ]; then
    . "/Users/canolab_13/.software/miniforge/etc/profile.d/mamba.sh"
fi
# <<< conda initialize <<<

