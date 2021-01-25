{ lib, pkgs, ... }:
let inherit (lib) fileContents;
in
{
  imports = [
    # User specific stuff
    # ./restic
    ./syncthing
  ];
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
        ../profiles/graphical
        ../profiles/emacs
        ../profiles/xmonad
        ../profiles/zsh
      ] ++ homeModules;
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
  environment.shellInit = ''
    export STARSHIP_CONFIG=${
      pkgs.writeText "starship.toml" (fileContents ./starship.toml)
    }
  '';
}
