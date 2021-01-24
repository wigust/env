{ pkgs, ... }: {
  home.packages = with pkgs; [
    cachix
    nix-index
    nix-prefetch-git
    nix-prefetch-github
    nix-prefetch-scripts
    nixpkgs-fmt
    nixops
    nixos-generators
    nix-linter
  ];
}
