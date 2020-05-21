self: super:

let
  ormolu = import (super.fetchFromGitHub {
    owner = "tweag";
    repo = "ormolu";
    rev = "d579a48f48cf732730fd958a2903c8a045dff146";
    sha256 = "0hpzvmvf08hbzc1pzv8iy7lzx6dzv2908722a70j5wriaxvabdd5";
  }) { pkgs = self; };
in {
  haskell = super.haskell // {
    packages = super.haskell.packages // {
      "${ormolu.ormoluCompiler}" =
        super.haskell.packages.${ormolu.ormoluCompiler}.override {
          overrides = ormolu.ormoluOverlay;
        };
    };
  };
}
