{pkgs, ...}:{
    imports = [
        ../../users/work
    ];
    environment.shells = with pkgs; [zsh];
    programs.zsh.enable = true;
    nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
      sha256 = "1jxiir415sldznwab5d03zffnkv5p8r2hqvzc51zcsf6dmsa9dk5";
    }))
  ];
    networking.hostName = "bbuscarino";
}