self: super:
let
  haskellNixSrc = import (builtins.fetchGit {
    url = "https://github.com/input-output-hk/haskell.nix.git";
    rev = "9321cfa3caf88be5864a0cc944d7f68b7675927d";
  }) { };
  nixpkgsSrc = haskellNixSrc.sources.nixpkgs-2003;
  nixpkgsArgs = haskellNixSrc.nixpkgsArgs;
  haskell-nix = (import nixpkgsSrc nixpkgsArgs).haskell-nix;
in {
  unison = (haskell-nix.stackProject {
    src = builtins.fetchGit {
      url = "https://github.com/unisonweb/unison.git";
      rev = "07814644d6f2305960a7047ffd7d6821b14e92d1";
    };
  }).summoner.components.exes.summon;
}
