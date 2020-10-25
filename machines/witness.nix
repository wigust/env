# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, stdenv, ... }:
with lib; {
  imports = [
    # Include the results of the hardware scan.
    ./witness-hardware.nix
    # Cachix
    ../cachix.nix
  ];
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    trustedUsers = [ "root" "ben" ];
  };
  nixpkgs = {

    overlays =
      [ (import ../overlays/packages.nix) (import ../overlays/haskell.nix) ];

    config = {
      # Allow un-free packages
      allowUnfree = true;
      chromium = { enableWideVine = true; };
    };
  };

  boot = {
    loader = {
      grub.enable = true;
      grub.version = 2;
      # Define on which hard drive you want to install Grub.
      grub.device = "/dev/nvme0n1"; # or "nodev" for efi only
      grub.extraEntries = ''
        menuentry "Windows 10" {
          chainloader (hd0,1)+1
        }
      '';
    };
    extraModulePackages = [ config.boot.kernelPackages.exfat-nofuse ];
    kernelModules = [ "kvm-amd" "nvidia" ];
    supportedFilesystems = [ "ntfs" ];
  };

  virtualisation = { docker.enable = true; };

  # Set the time zone.
  time.timeZone = "America/Detroit";

  environment = {
    variables = {
      "_JAVA_AWT_WM_NONREPARENTING" = "1";
      "EDITOR" = "${pkgs.emacs}/bin/emacs";
    };
    shellAliases = rec {
      switch =
        "sudo nixos-rebuild switch --flake ${config.users.users.ben.home}/env";
      upgrade = "${switch} --upgrade";
    };
    systemPackages = with pkgs; [
      # Utilities
      git
      zsh-powerlevel10k
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
      killall
      direnv

      # Terminal
      alacritty

      # Node
      nodejs-12_x
      yarn

      # Internet & media
      unstable.chromium
      vlc
      spotify
      epdfview
      nomacs
      libreoffice

      # Games
      unstable.steam
      pyfa
      unstable.discord
      eve-online
      # Chat apps
      slack

      # Python
      (python38Full.withPackages
        (ps: with ps; [ setuptools pip virtualenv tkinter ]))
      python38Packages.poetry
      python38Packages.black

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
      (let
        extensions = (with vscode-extensions; [
          bbenoist.Nix
          unstable.vscode-extensions.ms-vsliveshare.vsliveshare
          ms-python.python
          ms-azuretools.vscode-docker
          ms-vscode-remote.remote-ssh
        ]) ++ vscode-utils.extensionsFromVscodeMarketplace [{
          name = "remote-ssh-edit";
          publisher = "ms-vscode-remote";
          version = "0.47.2";
          sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
        }];
      in vscode-with-extensions.override { vscodeExtensions = extensions; })
      jetbrains.idea-ultimate
      jetbrains.pycharm-professional
      unstable.jetbrains.rider
      jetbrains.datagrip
      jetbrains.jdk

      # Dotnet
      unstable.dotnet-sdk_5

      # For the dumping and loading tools
      postgresql_12

      # Haskell
      unstable.stack
      haskell.compiler.ghc8101
      cabal-install
      ormolu
      hlint
      exercism
      summoner
      # haskell-language-server

      # Unison
      unison-ucm

      # Docker
      docker-compose
      docker-machine

      # Actions
      unstable.act

      # Git
      gitAndTools.git-fame
      git-crypt
      git-lfs

      # Nix tools
      cachix
      nixops
      nixfmt
      nixos-generators
      unstable.nix-prefetch-github
      nix-index
      niv
    ];
  };

  fonts = {
    fontDir.enable = true;
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
    devmon.enable = true;
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
      displayManager = {
        lightdm = {
          enable = true;
          greeters.pantheon.enable = true;
        };
        sessionCommands = ''
          ${pkgs.xorg.xrandr}/bin/xrandr --output DVI-D-0 --primary --mode 1920x1080 --pos 1920x0 --rotate normal --output HDMI-0 --mode 1920x1080 --pos 0x0 --rotate normal --output DP-0 --mode 1920x1080 --pos 3840x0 --rotate normal --output DP-1 --off
          ${pkgs.nitrogen}/bin/nitrogen --restore
        '';
        defaultSession = "none+xmonad";
      };
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
      extraPackages = with pkgs; [
        libva
        libGL_driver
        config.boot.kernelPackages.nvidia_x11.out
      ];
    };
    pulseaudio = {
      enable = true;
      support32Bit = true;
    };
  };
  users = {
    defaultUserShell = pkgs.zsh;

    users.ben = rec {
      uid = 1000;
      isNormalUser = true;
      extraGroups =
        [ "wheel" "plugdev" "networkmanager" "docker" "libvirtd" "disk" ];
      initialPassword = "1234";
      home = "/home/ben";
      openssh.authorizedKeys.keyFiles = [
        (../. + (builtins.toPath "/credentials/ssh/ben@busc.pub"))
        ../credentials/ssh/id_rsa.pub
      ];
    };

    extraGroups.vboxusers.members = [ "ben" ];
  };

  programs = {
    ssh = { startAgent = true; };
    zsh = {
      enable = true;
      shellInit = ''
        eval "$(${pkgs.direnv}/bin/direnv hook zsh)"
        . $HOME/.p10k.zsh
      '';
      promptInit =
        "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      ohMyZsh = {
        enable = true;
        plugins = [ "git" "docker" "docker-compose" "pip" ];
      };
    };

  };

  system.stateVersion = "20.03";
}
