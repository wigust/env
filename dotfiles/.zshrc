# ZSH Path
export ZSH=$HOME/.oh-my-zsh
export EDITOR="emacs"

# Personal settings
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Plugins
plugins=(git docker docker-compose)
plugins+=(node)
plugins+=(nvm)
plugins+=(cabal stack mix pip yarn)


# Theme
ZSH_THEME="avit"
source $ZSH/oh-my-zsh.sh

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Do OS specific things
if [[ $OSTYPE == darwin* ]]; then
  plugins+=(osx)
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
  export NIX_PATH=nixpkgs=$NIX_PATH/nixpkgs
  export PATH="$HOME/.local/bin:$PATH"
  export PATH="$HOME/.poetry/bin:$PATH"
  export NIX_IGNORE_SYMLINK_STORE=1
  . $HOME/.nix-profile/etc/profile.d/nix.sh
  
else
  alias switch='sudo nixos-rebuild switch --upgrade'

  export PATH="$HOME/.poetry/bin:$PATH"
  # Fix for Java applets - https://wiki.haskell.org/Xmonad/Frequently_asked_questions#Problems_with_Java_applications.2C_Applet_java_console
  export _JAVA_AWT_WM_NONREPARENTING=1
  export EDITOR="emacs"

  eval "$(direnv hook zsh)"
  eval "$(pyenv init -)"

  source ~/.nix-profile/etc/profile.d/hm-session-vars.sh
fi
