final: prev:

let source = prev.fetchFromGitHub {
      owner = "tweag";
      repo = "ormolu";
      rev = "de279d80122b287374d4ed87c7b630db1f157642"; # update as necessary
      sha256 = "0qrxfk62ww6b60ha9sqcgl4nb2n5fhf66a65wszjngwkybwlzmrv"; # same
    };
    ormolu = import source { pkgs = final; };
in {
  haskell = prev.haskell // {
    packages = prev.haskell.packages // {
      "${ormolu.ormoluCompiler}" = prev.haskell.packages.${ormolu.ormoluCompiler}.override {
        overrides = ormolu.ormoluOverlay;
      };
    };
  };
}
