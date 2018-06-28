# CLI Tools
xcode-select --install

# Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
cp .zshrc ~/.zshrc

# Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Tools
brew install git yarn

# NVM
brew install nvm
nvm install node

# Erlang and Elixir
brew install kerl
\curl -sSL https://raw.githubusercontent.com/taylor/kiex/master/install | bash -s
kiex install 1.6.5
kerl build 20.3 20.3

# Python
brew install pipenv pyenv
pyenv install 3.6.5

# Docker + k8s
brew cask install docker google-cloud-sdk
brew install kubernetes-cli kubernetes-helm

# Others
brew install openssl@1.1 libpng chromedriver watchman

# Personal tools
brew cask install \
anki \
dropbox \
eddie \
mactex \
postman \
transmission \
visual-studio-code \
vlc \
iterm2