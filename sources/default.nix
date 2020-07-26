let
  bootstrap = import <nixpkgs> { };
  inherit (bootstrap) fetchFromGitHub;
  loadJSON = f: fetchFromGitHub (builtins.fromJSON (builtins.readFile f));
in {
  # nix-prefetch-github nixos nixpkgs > master.json
  master = import (loadJSON ./master.json);
  hls-nix = import (loadJSON ./hls-nix.json);
}
