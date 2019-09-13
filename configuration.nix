# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  all-hies = import (fetchTarball "https://github.com/infinisil/all-hies/tarball/master") {};
in
{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      # Also include binary caches managed by cachix
      /etc/nixos/cachix.nix
      "${builtins.fetchTarball https://github.com/rycee/home-manager/archive/master.tar.gz}/nixos"
    ];
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/nvme0n1"; # or "nodev" for efi only

  networking.hostName = "busc-nixos"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Set the time zone.
  time.timeZone = "America/Detroit";
  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git oh-my-zsh wget curl

    google-chrome chromium vlc epdfview steam konsole

    cachix sqlite gparted ark home-manager exa

    python3 pipenv python37Packages.virtualenv

    emacs jetbrains.clion jetbrains.datagrip jetbrains.idea-ultimate vscode

    jetbrains.jdk bazel gradle

    cmake gnumake clang
    stack ghc stack2nix cabal-install cabal2nix

    (all-hies.selection { selector = p: { inherit (p) ghc865; }; })
  ];

  fonts.enableFontDir = true;
  fonts.enableDefaultFonts = true;
  fonts.enableCoreFonts = true;
  fonts.fonts = with pkgs; [
    corefonts
    font-awesome-ttf
    fira-code
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  networking.firewall.allowedTCPPorts = [ ];
  networking.firewall.allowedUDPPorts = [ ];

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;

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
        i3blocks #if you are planning on using i3blocks over i3status
        feh
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
    ]; # Enable ‘sudo’ for the user.
    initialPassword = "1234";
  };

  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.docker.enableOnBoot = true;

  networking.extraHosts =
    ''
      192.168.86.38 desktop.busc
      192.168.86.235 laptop.busc
    '';

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03"; # Did you read the comment?
}
