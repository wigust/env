# override defaults to nixpkgs/master
{
  # modules to pull from override, stable version is automatically disabled
  modules = [ ];

  # if a modules name changed in override, add the old name here
  disabledModules = [ ];

  packages = pkgs: final: prev:
    {
      inherit (pkgs)
        cachix
        dhall
        discord
        discord-canary
        element-desktop
        emacs
        emacsGcc
        jetbrains
        manix
        nixos-generators
        nixpkgs-fmt
        qutebrowser
        signal-desktop
        slack
        spotify;

      haskellPackages = prev.haskellPackages.override {
        overrides = hfinal: hprev:
          let version = prev.lib.replaceChars [ "." ] [ "" ] prev.ghc.version;
          in
          {
            # same for haskell packages, matching ghc versions
            inherit (pkgs.haskell.packages."ghc${version}")
              haskell-language-server;
          };
      };
    };
}
