# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, stdenv, ... }:
with lib; {
  imports = [
    # Include the results of the hardware scan.
    /etc/nixos/hardware-configuration.nix
    # Pin the 20.03 home-manager release instead of using channels
    (import (fetchTarball
      "https://github.com/rycee/home-manager/archive/release-20.03.tar.gz")
      { }).nixos

    # Cachix
    ../cachix.nix

    # Ly
    ../modules/ly.nix
  ];
  nix.trustedUsers = [ "root" "ben" ];
  nixpkgs = {

    overlays = [
      (import ../overlays/haskell.nix)
      (import ../overlays/chromium.nix)
      (import ../overlays/steam.nix)
      (import ../overlays/nix.nix)
    ];

    config = {
      # Allow un-free packages
      allowUnfree = true;
      allowBroken = true;
      chromium = { enableWideVine = true; };
    };
  };

  boot = {
    loader = {
      grub.enable = true;
      grub.version = 2;
      # Define on which hard drive you want to install Grub.
      grub.device = "/dev/nvme0n1"; # or "nodev" for efi only
    };
    extraModulePackages = [ config.boot.kernelPackages.exfat-nofuse ];
    kernelModules = [ "kvm-amd" "kvm-intel" ];
  };

  virtualisation = {
    libvirtd.enable = true;
    docker.enable = true;
  };

  # Set the time zone.
  time.timeZone = "America/Detroit";

  environment = {
    variables = { "_JAVA_AWT_WM_NONREPARENTING" = "1"; };
    systemPackages = with pkgs; [
      # Utilities
      git
      oh-my-zsh
      wget
      curl
      ispell
      ag
      exa
      gparted
      ark
      direnv
      gnumake
      htop
      xclip
      pandoc
      killall

      # Terminal
      alacritty
      hyper

      # Node
      nodejs-12_x
      yarn

      # Internet & media
      google-chrome
      chromium
      vlc
      spotify
      epdfview
      nomacs
      libreoffice

      # Games
      steam

      # Chat apps
      discord
      slack
      mattermost

      # Python
      (python38Full.withPackages (ps: with ps; [ setuptools pip virtualenv ]))
      python38Packages.poetry
      python3Packages.black
      python3Packages.python-language-server

      # Window manager stuff
      dmenu
      nitrogen
      dunst
      rofi
      arandr
      pavucontrol
      breeze-gtk
      xmobar

      # IDEs and editors
      emacs
      vscode
      jetbrains.idea-ultimate
      jetbrains.datagrip
      jetbrains.jdk

      # For the dumping and loading tools
      postgresql_12

      # Haskell
      stack
      haskell.compiler.ghc8101
      cabal-install
      ormolu
      hlint
      exercism
      summoner
      haskell-language-server

      # Docker
      docker-compose
      docker-machine

      # Git
      gitAndTools.git-fame
      git-crypt

      # Nix tools
      cachix
      nixops
      nixfmt
      nixos-generators
      nix-prefetch-github
      niv
    ];
  };

  fonts = {
    enableFontDir = true;
    enableDefaultFonts = true;
    fonts = with pkgs; [
      corefonts
      font-awesome-ttf
      fira-code
      fira-code-symbols
      jetbrains-mono
      siji
      noto-fonts
    ];
  };

  services = {
    udev.extraRules = ''
      # Rule for the Ergodox EZ Original / Shine / Glow
      SUBSYSTEM=="usb", ATTR{idVendor}=="feed", ATTR{idProduct}=="1307", GROUP="plugdev"
    '';
    # Enable the OpenSSH daemon.
    openssh = {
      enable = true;
      passwordAuthentication = false;
    };
    syncthing = {
      enable = true;
      user = "ben";
      dataDir = "${config.users.users.ben.home}/.syncthing";
    };
    lorri.enable = true;

    # Enable the X11 windowing system.
    xserver = {
      enable = true;
      layout = "us";
      desktopManager.xterm.enable = false;
      displayManager.ly.enable = true;
      displayManager.defaultSession = "none+xmonad";
      videoDrivers = [ "nvidia" ];

      windowManager.xmonad = {
        enable = true;
        extraPackages = with pkgs; (hs: [ hs.xmobar ]);
        enableContribAndExtras = true;
        config = ../dotfiles/xmonad/xmonad.hs;
      };
    };
  };

  networking = {
    hostName = "witness";
    networkmanager.enable = true;
    firewall = {
      allowedTCPPorts = [ 22 19001 19002 22000 ];
      allowedUDPPorts = [ 22 19001 19002 21027 ];
    };
  };

  # Enable sound.
  sound.enable = true;

  hardware = {
    opengl = {
      enable = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [ libva ];
    };
    pulseaudio = {
      enable = true;
      support32Bit = true;
    };
  };
  users = {
    defaultUserShell = pkgs.zsh;

    users.ben = rec {
      isNormalUser = true;
      extraGroups = [ "wheel" "plugdev" "networkmanager" "docker" "libvirtd" ];
      initialPassword = "1234";
      home = "/home/ben";
      openssh.authorizedKeys.keyFiles =
        [ "${home}/.ssh/ben@busc.pub" "${home}/.ssh/id_rsa.pub" ];
    };
  };

  home-manager.users.ben = import ../home.nix {
    inherit pkgs;
    inherit (users.users.ben) home;
  };

  programs = {
    ssh = { startAgent = true; };
    zsh.enable = true;
  };

  system.stateVersion = "20.03";
}
