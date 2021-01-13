{ pkgs, ... }:
let inherit (builtins) readFile;
in
{
  imports = [ ../develop ../network ./im ];

  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.pulseaudio.enable = true;

  boot = {

    kernelPackages = pkgs.linuxPackages_5_9;

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
      dmenu
      nitrogen
      dunst
      rofi
      arandr
      pavucontrol
      xmobar
      networkmanager
    ];
  };

  services.gnome3.gnome-keyring.enable = true;

  services.xserver = {
    enable = true;
    displayManager.lightdm.greeters.gtk = {
      enable = true;
      theme = {
        package = pkgs.breeze-gtk;
        name = "Breeze";
      };
      iconTheme = {
        package = pkgs.breeze-icons;
        name = "Breeze";
      };
    };
  };
}
