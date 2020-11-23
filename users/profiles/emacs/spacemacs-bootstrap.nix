(import ./spacemacs-with-packages.nix { pkgs = import <nixpkgs> { }; }) {
  layers = ls: [ ls.spacemacs-bootstrap ];
}
