{ pkgs, ... }: {
  nixpkgs = {

    overlays = [
      (import ../overlays/ptvsd.nix)
      (import (builtins.fetchTarball {
        url =
          "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
      }))
    ];

    config = {
      # Allow un-free packages
      allowUnfree = true;
      chromium = { enableWideVine = true; };
    };
  };
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes ca-references
    min-free = 536870912
  '';
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    # env
    direnv
    ag

    # Editors

    # Java
    # adoptopenjdk-jre-bin

    # Python
    (python38Full.withPackages
      (ps: with ps; [ setuptools pip virtualenv ptvsd ]))
    python38Packages.poetry
    python3Packages.black
    python3Packages.autopep8
    python3Packages.pylint
    #python3Packages.python-language-server

    # Nix tools
    nixfmt
    nixops
    cachix
    nixos-generators
    nix-prefetch-github
    (callPackage "${
        fetchFromGitHub {
          owner = "datakurre";
          repo = "pip2nix";
          rev = "ac78f86aa427eee976c06ba2fca77a1ed95b881e";
          sha256 = "0vlxj02hc3wgzrxvynf33s2dc430p63pfcml0l99ndxvdvk1j219";
        }
      }/release.nix" { }).pip2nix.python37

    # Docker
    docker-compose
    docker-machine
  ];

  fonts.enableFontDir = true;
  fonts.fonts = with pkgs; [
    font-awesome-ttf
    fira-code
    fira-code-symbols
    jetbrains-mono
    siji
    noto-fonts
  ];

  programs.zsh.enable = true;
  programs.zsh.enableCompletion = true;
  programs.zsh.enableBashCompletion = false;
}
