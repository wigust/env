#!/usr/bin/env bash
DIR="$(dirname "${BASH_SOURCE[0]}")"  # get the directory name
DIR="$(realpath "${DIR}")"    # resolve its full path if need be
$DIR/spacemacs2nix.el > $DIR/all-spacemacs-packages.nix
$DIR/dotspacemacs-used-layers.el > $DIR/layers.nix
$DIR/dotspacemacs-used-themes.el > $DIR/themes.nix