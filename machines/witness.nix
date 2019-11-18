# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  all-hies = import (fetchTarball "https://github.com/infinisil/all-hies/tarball/master") {};
  bitwig-studio3 = pkgs.bitwig-studio1.overrideAttrs (oldAttrs: rec {
    name = "bitwig-studio-${version}";
    version = "3.0.3";
  
    src = builtins.fetchurl {
      url = "https://downloads.bitwig.com/stable/${version}/bitwig-studio-${version}.deb";
      sha256 = "162l95imq2fb4blfkianlkymm690by9ri73xf9zigknqf0gacgsa";
    };
    
    runtimeDependencies = [
      pkgs.pulseaudio
    ];
  });
in
{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      # Also include binary caches managed by cachix
      /etc/nixos/cachix.nix
      # Includes
      #./yubikey-gpg.nix
      "${builtins.fetchTarball https://github.com/rycee/home-manager/archive/master.tar.gz}/nixos"
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
  
  environment.systemPackages = with pkgs; [
    # Utilities
    git oh-my-zsh
    wget curl
    ispell
    ranger ag exa
    gparted ark

    # Node
    yarn

    # Elm
    elmPackages.elm elmPackages.elm-format glibc

    # Internet & media
    google-chrome chromium
    vlc spotify
    epdfview
    (steam.override { extraPkgs = pkgs: [ pkgsi686Linux.libva ]; })
    bitwig-studio3 jack2Full

    # Terminal tools
    konsole

    # Nix tools
    cachix home-manager

    # GnuPG
    gnupg

    # Python
    (python3.withPackages(ps: with ps; [ pip ]))
    python3Packages.poetry python3Packages.python-language-server python3Packages.yapf
    sqlite

    # IDEs and editors
    emacs vscode
    jetbrains.clion jetbrains.datagrip jetbrains.pycharm-professional jetbrains.idea-ultimate

    # Java
    jetbrains.jdk bazel gradle

    # C/C++
    cmake gnumake clang cquery

    # Haskell
    stack ghc cabal-install
    (all-hies.selection { selector = p: { inherit (p) ghc865; }; })

    # Docker
    docker-compose

    # Elixir
    elixir_1_8 inotify-tools
  ];

  fonts = {
    enableFontDir = true;
    enableDefaultFonts = true;
    enableCoreFonts = true;
    fonts = with pkgs; [
      corefonts
      font-awesome-ttf
      fira-code
      fira-code-symbols
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
    hostName = "busc-nixos"; # Define your hostname.
    networkmanager.enable = true;
    firewall = {
      allowedTCPPorts = [ 22 22000 ];
      allowedUDPPorts = [ 21027 ];
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
      "docker"
    ];
    initialPassword = "1234";
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDVF0rotg5vBTwhvQqNIJBh6AED9kaSW9lkzxxcnLhnoAPbXfRm59XGfxWIi8zKXeExWO3ftLhAJWpLCmNpYlUNCd0KJiUq3Q/Q5RZF5cQomqwj3toPISHE3JnjNAyzLFq+h/AbB/Rw28zdwUeH/yuCn6fChI66A+JA4/THwBbG0NCidAkP4Aby3vlBRGJAnjSCkPW7686qAeLHZydPwum/EQCQuWVAYqfVHGLa0GIhCmJeloW0qR2QmMRomgHPLmlJYMsY8H36/KHfJzNH6FjkGsaJX1ex3a84JGdG4r0k7ulae6ZoSx2c5EQ2jVGysuppDP/7RWfO2cB32n/0EtqJbJtqgb3dr7bGKmMt+Zh76J55rtRj+wXbMpwKyx0Vb/6dUtxys8z+K5uNrZIN7KWi8xhfIjLn5iFxb8GsPbIbt9VQHe1yFGw7HwcRNODCCx5zifDEAWUujOjXP4fhxrVzhPmlRbBqplwZi2+J44CwszIw3ledF6H2vLEppF0fq5COVlaEnvCr2zUZ/SneOLI78wnNhruy22XWKmJggs634HvLDk5JlSVKHZtFwCu+1LG+20fEZma2uHQApuh9hEpxkLvH1+wBaIN5HJCpuMoMktqM9rZFfFok3tlo7bDr+Wlfu9V4GqlKXa5lvbpEo74XHq3xxQIyJUAoV4xGfN2SqQ== ben@nixos" ];
  };

  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  networking.extraHosts =
    ''
      192.168.86.38 desktop.busc
      192.168.86.235 laptop.busc
    '';

  system.stateVersion = "19.03";
}
