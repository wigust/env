# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
with lib;
let
  unstable = import (builtins.fetchGit {
  name = "nixpkgs-unstable-2020-01-13";
  url = "https://github.com/NixOS/nixpkgs-channels";
  ref = "nixos-unstable";
  # `git ls-remote https://github.com/nixos/nixpkgs-channels nixos-unstable`
  rev = "c438ce12a858f24c1a2479213eaab751da45fa50";
}) {};
  easyPS = import (pkgs.fetchFromGitHub {
    owner = "justinwoo";
    repo = "easy-purescript-nix";
    rev = "14e7d85431e9f9838d7107d18cb79c7fa534f54e";
    sha256 = "0lmkppidmhnayv0919990ifdd61f9d23dzjzr8amz7hjgc74yxs0";
  }) {
    inherit pkgs;
  };
in
{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      # Also include binary caches managed by cachix
      /etc/nixos/cachix.nix
      <home-manager/nixos>
      # Includes
      #./yubikey-gpg.nix
      (builtins.fetchTarball {
       url = "https://github.com/msteen/nixos-vsliveshare/archive/e6ea0b04de290ade028d80d20625a58a3603b8d7.tar.gz";
       sha256 = "12riba9dlchk0cvch2biqnikpbq4vs22gls82pr45c3vzc3vmwq9";
      })
    ];
  # Allow unfree packages
  nixpkgs.config = {
    allowBroken = true;
    allowUnfree = true;  
  };

  # Use the GRUB 2 boot loader.
  boot.loader = {
    grub.enable = true;
    grub.version = 2;
    # Define on which hard drive you want to install Grub.
    grub.device = "/dev/nvme0n1"; # or "nodev" for efi only
  };

  # boot.extraModulePackages = with config.boot.kernelPackages; [ exfat-nofuse ];

  # Set the time zone.
  time.timeZone = "America/Detroit";

  services.udev.packages = with pkgs; [
    yubikey-personalization
  ];


  services.lorri.enable = true;

  programs.ssh.startAgent = false;

  services.pcscd.enable = true;
  environment.shellInit = ''
    gpg-connect-agent /bye
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  '';

  environment.systemPackages = with pkgs; with easyPS; [
    # Utilities
    git oh-my-zsh
    wget curl
    ispell
    ranger ag exa
    gparted ark
    obs-studio
    direnv
    postgresql_11
    
    inkscape
    zoom-us

    thunderbird

    gitkraken gitAndTools.git-fame

    # Node
    nodejs yarn

    # Elm
    elmPackages.elm elmPackages.elm-format glibc

    # Internet & media
    google-chrome chromium 
    vlc spotify
    epdfview
    (steam.override { extraPkgs = pkgs: [ pkgsi686Linux.libva ]; }) discord

    # Terminal tools
    konsole

    # Nix tools
    cachix home-manager

    # GnuPG
    gnupg yubikey-personalization

    # Python
    (python38Full.withPackages(ps: with ps; [ setuptools pip tkinter virtualenv ]))
    sqlite nix-index
    libxslt.dev libxml2.dev libjpeg.dev openblasCompat liblapack

    # IDEs and editors
    emacs vscode
    jetbrains.clion jetbrains.datagrip jetbrains.pycharm-professional jetbrains.idea-ultimate

    # Java
    jetbrains.jdk bazel gradle

    # C/C++
    cmake gnumake clang cquery gcc

    # Haskell
    stack ghc cabal-install

    # Docker
    docker-compose kompose

    # Purescript
    spago purs pscid
  ];

  services.vsliveshare = {
    enable = true;
    enableWritableWorkaround = true;
    enableDiagnosticsWorkaround = true;
    extensionsDir = "/home/ben/.vscode/extensions";
  };

  services.udev.extraRules = ''
     # Rule for the Ergodox EZ Original / Shine / Glow
     SUBSYSTEM=="usb", ATTR{idVendor}=="feed", ATTR{idProduct}=="1307", GROUP="plugdev"
     # Rule for the Planck EZ Standard / Glow
     SUBSYSTEM=="usb", ATTR{idVendor}=="feed", ATTR{idProduct}=="6060", GROUP="plugdev"
  '';

  fonts = {
    enableFontDir = true;
    enableDefaultFonts = true;
    enableCoreFonts = true;
    fonts = with pkgs; [
      corefonts
      font-awesome-ttf
      fira-code
      fira-code-symbols
      unstable.jetbrains-mono
    ];
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
  };

  services.syncthing = {
    enable = true;
    user = "ben";
    dataDir = "/home/ben/.syncthing";
  };

  networking = {
    hostName = "busc-nixos";
    firewall = {
      allowedTCPPorts = [ 22 22000 ];
      allowedUDPPorts = [ 22 21027 ];
    };
  };

  # Enable sound.
  sound.enable = true;

  hardware = {
    pulseaudio.enable = true;
    opengl = {
      driSupport32Bit = true;
      enable = true;
      extraPackages = with pkgs; [
        libva
      ];
    };
    pulseaudio.support32Bit = true;
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";
    desktopManager = {
      default = "none";
      xterm.enable = false;
    };

    videoDrivers = [ "nvidia" ];

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu #application launcher most people use
        i3status # gives you the default i3 status bar
        i3lock #default i3 screen locker
        hsetroot
        dunst
        rofi
        arandr
        pavucontrol
        breeze-gtk
     ];
    };
  };

  users.users.ben = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "plugdev"
      "networkmanager"
      "docker"
    ];
    initialPassword = "1234";
    openssh.authorizedKeys.keyFiles = [ 
      "/home/ben/.ssh/ben@busc.pub"
      "/home/ben/.ssh/id_rsa.pub"
    ];
  };
  home-manager.users.ben = import ../home.nix;

  virtualisation.docker.enable = true;

  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  networking.networkmanager.enable = true;

  networking.extraHosts =
    ''
      192.168.86.38 desktop.busc
      192.168.86.235 laptop.busc
    '';

  system.stateVersion = "19.09";
}
