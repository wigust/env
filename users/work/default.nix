{ lib, pkgs, ... }: {
  imports = [ ];
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.bbuscarino = { home, config, homeModules, ... }:
    with home; {
      imports = [
        ../profiles/develop
        #../profiles/develop/haskell
        ../profiles/develop/nix
        ../profiles/develop/cpp
        ../profiles/develop/python
        ../profiles/direnv
        ../profiles/emacs
        ../profiles/git
        #../profiles/im
        ../profiles/zsh
      ] ++ homeModules;

      home.file = {
        ".gitconfig".source = ../../secrets/dotfiles/work.gitconfig;
      };
    };
}
