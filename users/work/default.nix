{ lib, pkgs, ... }: {
  imports = [ ];
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.ben = { home, config, ... }:
    with home; {
      imports = [
        ../profiles/alacritty
        ../profiles/develop
        ../profiles/develop/direnv
        ../profiles/develop/git
        ../profiles/develop/nix
        ../profiles/develop/python
        ../profiles/emacs
        ../profiles/zsh
      ];

      home.file.".gitconfig".source = ../../secrets/dotfiles/work.gitconfig;
    };
}
