{ lib, pkgs, ... }:
let inherit (lib) fileContents;
in
{
  home-manager.users.ben = { home, config, homeModules, ... }:
    with home; {
      imports = [
        ../profiles/develop
        ../profiles/direnv
        ../profiles/emacs
        ../profiles/git
        ../profiles/graphical
        ../profiles/zsh
        ../profiles/gpg
      ] ++ homeModules;

      home.file = {
        ".gitconfig".source = ../../secrets/dotfiles/home.gitconfig;
      };
    };

  users.users.ben = {
    uid = 1000;
    # mkpasswd -m sha-512 hunter1 >> ./ben.hashedPassword
    hashedPassword = lib.fileContents ../ben/ben.hashedPassword;
    isNormalUser = true;
    home = "/home/ben";
    extraGroups =
      [ "wheel" "plugdev" "networkmanager" "docker" "libvirtd" "disk" ];
    openssh.authorizedKeys.keyFiles = [
      (../../. + (builtins.toPath "/secrets/credentials/ssh/ben@busc.pub"))
      ../../secrets/credentials/ssh/id_rsa.pub
      ../../secrets/credentials/ssh/yubikey.pub
    ];
  };
  users.defaultUserShell = pkgs.zsh;
}
