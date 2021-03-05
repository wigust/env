{ lib, pkgs, ... }:
let inherit (lib) fileContents;
in
{
  imports = [
    # User specific stuff
    # ./restic
    ./syncthing
  ];
  home-manager.users.ben = { home, config, homeModules, ... }:
    with home; {
      imports = [
        ../profiles/alacritty
        ../profiles/develop
        ../profiles/develop/nix
        ../profiles/develop/purescript
        ../profiles/develop/python
        ../profiles/direnv
        ../profiles/emacs
        ../profiles/git
        ../profiles/graphical
        ../profiles/im
        ../profiles/xmonad
        ../profiles/zsh
        ../profiles/gpg
      ] ++ homeModules;

      home.file = {
        ".gitconfig".source = ../../secrets/dotfiles/home.gitconfig;
        ".background-image".source = ../../assets/wallpaper.png;
      };
    };

  users.users.ben = {
    uid = 1000;
    # mkpasswd -m sha-512 hunter1 >> ./ben.hashedPassword
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
