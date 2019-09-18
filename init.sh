#!/bin/bash
# Installs all the dotfiles and such with home-manager


print() {
    echo -e "\e[32;1m$1\e[0m"
}

ensure_installed() {
    if ! hash $1 2>/dev/null; then
        print "Installing $1\..."
        nix-env -e $1
    fi
}

if ! hash nix 2>/dev/null; then
    print "Installing nix..."
    curl https://nixos.org/nix/install | sh
fi
ensure_installed git
print "Cloning env..."
git clone git@github.com:bbuscarino/env.git $HOME\/env
ensure_installed home-manager
print "Activating home..."
home-manager -f $HOME\/env/home.nix switch
print "Done!"
exit 0
