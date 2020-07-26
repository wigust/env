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
  summoner = (haskell-nix.cabalProject {
    src = builtins.fetchGit {
      url = "https://github.com/kowainik/summoner";
      rev = "a6b3c4fc0ed0a631b33dc2db70af9099301fee09";
    };
  }).summoner.components.exes.summon;
}
