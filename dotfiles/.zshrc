# ZSH Path
export ZSH=$HOME/.oh-my-zsh
export EDITOR="emacs"

# Personal settings
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Plugins
plugins=(git docker docker-compose)
plugins+=(node)
plugins+=(nvm)
plugins+=(cabal pip yarn)


# Theme
ZSH_THEME="avit"

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Do OS specific things
if [[ $OSTYPE == darwin* ]]; then
  plugins+=(osx)

  # NVM
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

  # nix and nix-darwin
  export NIX_PATH=nixpkgs=$NIX_PATH/nixpkgs
  export NIX_PATH=darwin-config=$HOME/.nixpkgs/darwin-configuration.nix:$HOME/.nix-defexpr/channels:$NIX_PATH
  export PATH="$HOME/.poetry/bin:$PATH"
  export NIX_IGNORE_SYMLINK_STORE=1
  alias switch="$(nix-build '<darwin>' -A system --no-out-link)/sw/bin/darwin-rebuild switch"

  . $HOME/.nix-profile/etc/profile.d/nix.sh
  . /etc/static/zprofile
  . /etc/static/zshrc
else
  alias switch='sudo nixos-rebuild switch --upgrade'
  # Fix for Java applets - https://wiki.haskell.org/Xmonad/Frequently_asked_questions#Problems_with_Java_applications.2C_Applet_java_console
  export _JAVA_AWT_WM_NONREPARENTING=1
  source ~/.nix-profile/etc/profile.d/hm-session-vars.sh
fi

if hash direnv 2>/dev/null; then
    eval "$(direnv hook zsh)"
fi

source $ZSH/oh-my-zsh.sh
