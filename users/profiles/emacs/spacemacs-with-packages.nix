{ pkgs, ... }:

{ layers
, themes ? p: [ ]
, extraPackages ? p: [ ]
, emacsPackage ? pkgs.emacs
, overrides ? (epkgs: epkgs)
}:
let overriden = overrides (pkgs.emacsPackagesFor emacsPackage);
in
overriden.emacsWithPackages (epkgs:
  layers (import ./all-spacemacs-packages.nix epkgs) ++ themes epkgs
  ++ extraPackages epkgs)
