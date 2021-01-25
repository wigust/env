{ lib, pkgs, ... }: {
  imports = [ ];
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.ben = { home, config, homeModules, ... }:
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
      ] ++ homeModules;

      home.file.".gitconfig".source = ../../secrets/dotfiles/work.gitconfig;
    };
}
