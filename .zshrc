# ZSH Path
export ZSH=$HOME/.oh-my-zsh


# Personal settings
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Plugins
plugins=(brew common-aliases git docker docker-compose osx)
plugins+=(node)
plugins+=(cabal mix pip yarn)

# Theme
ZSH_THEME="avit"
source $ZSH/oh-my-zsh.sh

export PATH="$HOME/.local/bin:$PATH"

test -s "$HOME/.kiex/scripts/kiex" && source "$HOME/.kiex/scripts/kiex"
export NVM_DIR="$HOME/.nvm"
. "/usr/local/opt/nvm/nvm.sh"

# Pyenv init
eval "$(pyenv init -)"

[ -s "/Users/ben/.jabba/jabba.sh" ] && source "/Users/ben/.jabba/jabba.sh"

export ANDROID_HOME="/Users/ben/Library/Android/sdk"

