{ lib, pkgs, ... }: {
  imports = [
    # ../../profiles/develop
    # ../../profiles/graphical/games
    # ../../profiles/graphical
    # ../../profiles/develop/nix
    # # User specific stuff
    # ./restic
    # ./syncthing
  ];
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.ben = { home, config, ... }:
    with home; {
      imports = [
        ../profiles/git
        ../profiles/direnv
        ../profiles/alacritty
        ../profiles/zsh
        ../profiles/emacs
      ];

      home.file.".gitconfig".source = ../../secrets/dotfiles/work.gitconfig;
    };
}
