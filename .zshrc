# ZSH Path
export ZSH=$HOME/.oh-my-zsh

# Personal settings
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Plugins
plugins=(common-aliases git docker docker-compose)
plugins+=(node)
plugins+=(cabal mix pip yarn)

# Theme
ZSH_THEME="avit"
source $ZSH/oh-my-zsh.sh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
