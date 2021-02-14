with import <nixpkgs> { };
mkShell {
  buildInputs =  let
    projGhc = haskell.packages.ghc884.ghcWithPackages
    (ps: with ps; [
      xmonad
      xmonad-contrib
      xmonad-extras
    ]);
  in [
    projGhc
    (haskell.packages.ghc884.haskell-language-server.override {
      ghc = projGhc;
    })
  ];
}
