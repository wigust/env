{ pkgs ? import <nixpkgs> { }, version ? "8.8.3", tag ? "0.2.2" }:
((import ../sources).hls-nix {
  inherit version tag;
}).exes.haskell-language-server
