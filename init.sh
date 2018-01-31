# CLI Tools
xcode-select --install

# Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
cp .zshrc ~/.zshrc

# Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# NVM
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash
nvm install node

# JENV
brew install jenv
echo 'export PATH="$HOME/.jenv/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(jenv init -)"' >> ~/.zshrc

# Languages
brew tap caskroom/versions
brew install elixir elm erlang python python3 ruby rust
brew cask install java java8

brew tap homebrew/homebrew-php
brew install php72 composer

# Tools
brew install git grails gradle yarn

# Dev ops
brew cask install docker vagrant virtualbox
brew install ansible awscli

# Others
brew install openssl@1.1 libpng

# Personal tools
brew cask install \
anki \
dropbox \
eddie \
mactex \
postman \
robo-3t \
transmission \
visual-studio-code \
vlc