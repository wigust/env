{ pkgs, ... }:
let inherit (builtins) readFile;
in {
  imports = [ ../develop ./xmonad ../network ./im ];

  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.pulseaudio.enable = true;

  boot = {

    kernelPackages = pkgs.linuxPackages_5_8;

    tmpOnTmpfs = true;

    kernel.sysctl."kernel.sysrq" = 1;

  };

  environment = {

    etc = {
      "xdg/gtk-3.0/settings.ini" = {
        text = ''
          [Settings]
          gtk-theme-name=Breeze
        '';
        mode = "444";
      };
    };

    sessionVariables = {
      # Theme settings
      QT_QPA_PLATFORMTHEME = "gtk2";
    };

    systemPackages = with pkgs; [
      breeze-gtk
      dzen2
      gnome3.networkmanagerapplet
      pulsemixer
      dmenu
      nitrogen
      dunst
      rofi
      arandr
      pavucontrol
      xmobar
      chromium
      libreoffice
      spotify
      bitwig-studio3
    ];
  };

  services.gnome3.gnome-keyring.enable = true;

  services.xserver = {
    enable = true;

    displayManager.lightdm = {
      enable = true;
      greeters.pantheon.enable = true;
    };
    desktopManager.xterm.enable = false;
    displayManager.defaultSession = "none+xmonad";
    displayManager.sessionCommands = ''
      ${pkgs.xorg.xrandr}/bin/xrandr --output DVI-D-0 --primary --mode 1920x1080 --pos 1920x0 --rotate normal --output HDMI-0 --mode 1920x1080 --pos 0x0 --rotate normal --output DP-0 --mode 1920x1080 --pos 3840x0 --rotate normal --output DP-1 --off
      ${pkgs.nitrogen}/bin/nitrogen --restore
    '';
  };
}
