{ pkgs, emacs, ... }: {
  imports = [
    ../../users/work
  ];

  environment.shells = with pkgs; [ zsh ];
  programs.zsh.enable = true;
  users.nix.configureBuildUsers = true;
  nixpkgs.overlays = [
    emacs.overlay
  ];
  networking.hostName = "bbuscarino";

  homebrew = {
    enable = true;
    cleanup = "zap";
    global = {
      brewfile = true;
      noLock = true;
    };
    brews = [];
    casks = [
      "docker"
      "adobe-acrobat-reader"
      "jetbrains-toolbox"
      "keepassxc"
      "spotify"
      "vlc"
      "zoom"
      "iterm2"
      "microsoft-teams"
      "syncthing"
      "xquartz"
      "google-chrome"
      "karabiner-elements"
    ];
  };
}
