# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, stdenv, ... }:
with lib;
{
  imports = [
    # Include the results of the hardware scan.
    /etc/nixos/hardware-configuration.nix
    # Pin the 20.03 home-manager release instead of using channels
    (import (fetchTarball
      "https://github.com/rycee/home-manager/archive/release-20.03.tar.gz")
      { }).nixos
  ] ++ optional (builtins.pathExists "/etc/nixos/cachix.nix") /etc/nixos/cachix.nix;

  nixpkgs = {

    overlays = [
      (import ../overlays/ormolu.nix)
      (import ../overlays/chromium.nix)
      (import ../overlays/steam.nix)  ];

    config = {
      # Allow un-free packages
      allowUnfree = true;
      chromium = {
        enableWideVine = true;
      };
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

  environment.systemPackages = with pkgs; [
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

    # Node
    nodejs-12_x
    yarn

    # Internet & media
    google-chrome chromium
    vlc
    spotify
    epdfview
    nomacs
    libreoffice

    # Terminal tools
    alacritty

    steam discord

    # Python
    (python38Full.withPackages
      (ps: with ps; [ setuptools pip virtualenv ]))
    python38Packages.poetry
    python3Packages.black
    python3Packages.python-language-server

    # IDEs and editors
    emacs

    # Haskell
    stack
    ghc
    cabal-install
    (import (builtins.fetchTarball
      "https://github.com/cachix/ghcide-nix/tarball/master") { }).ghcide-ghc865
    ormolu

    # Docker
    docker-compose docker-machine

    # Git
    gitAndTools.git-fame

    # Nix tools
    cachix
    nixops
    nixfmt
    nixos-generators

    # Unholy, but pin to nixpkgs version so it doesn't get rebuilt all the time
    (wrapCC (gcc9.cc.override { langFortran = true; }))

  ];

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
      displayManager.lightdm.enable = true;
      displayManager.defaultSession = "none+xmonad";
      videoDrivers = [ "nvidia" ];

      windowManager.xmonad = {
        enable = true;
        extraPackages = with pkgs;( hs: [
          dmenu
          hs.xmobar
          nitrogen
          dunst
          rofi
          arandr
          pavucontrol
          breeze-gtk
        ]);
        enableContribAndExtras = true;
        config = ../dotfiles/xmonad/config.hs;
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
