#!/bin/sh
DIR=$(dirname "$0")
nix-prefetch-github nixos nikpkgs > $DIR/master.json
nix-prefetch-github bbuscarino hls-nix > $DIR/hls-nix.json