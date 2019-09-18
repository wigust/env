#!/bin/bash
# Installs all the dotfiles and such with home-manager

if ! hash nix 2>/dev/null; then
    echo "Installing nix..."
    curl https://nixos.org/nix/install | sh
fi
echo "Installing git..."
nix-env -e git
echo "Cloning env..."
git clone https://github.com/bbuscarino/env.git $HOME\/env
nix-env -e home-manager
home-manager -f $HOME\/env/home.nix switch
echo "Done!"
exit 0
