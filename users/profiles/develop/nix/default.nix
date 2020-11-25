{ pkgs, ... }: {
  home.packages = with pkgs; [
    cachix
    nix-index
    nix-prefetch-github
    nixfmt
    nixops
    nixos-generators
    nix-linter
  ];
}
