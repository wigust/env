{ lib, pkgs, ... }: {
  imports = [
    ../../profiles/develop
    ../../profiles/graphical/games
    ../../profiles/graphical
    ../../profiles/develop/nix
    # User specific stuff
    ./restic
    ./syncthing
  ];
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.ben = { home, config, ... }:
    with home; {
      imports = [
        ../profiles/git
        ../profiles/direnv
        ../profiles/alacritty
        ../profiles/xmonad
        ../profiles/emacs
        ../profiles/zsh
      ];
      home.file.".gitconfig".source = ../../secrets/dotfiles/home.gitconfig;
    };

  users.users.ben = {
    uid = 1000;
    hashedPassword = lib.fileContents ./ben.hashedPassword;
    isNormalUser = true;
    home = "/home/ben";
    extraGroups =
      [ "wheel" "plugdev" "networkmanager" "docker" "libvirtd" "disk" ];
    openssh.authorizedKeys.keyFiles = [
      (../../. + (builtins.toPath "/secrets/credentials/ssh/ben@busc.pub"))
      ../../secrets/credentials/ssh/id_rsa.pub
    ];
  };
  users.defaultUserShell = pkgs.zsh;
}
