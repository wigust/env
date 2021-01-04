{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    xclip
    dunst
  ];
  services.xserver = {
    displayManager.defaultSession = "none+xmonad";
    displayManager.sessionCommands = ''
      ${pkgs.xorg.xrandr}/bin/xrandr --output DVI-D-0 --primary --mode 1920x1080 --pos 1920x0 --rotate normal --output HDMI-0 --mode 1920x1080 --pos 0x0 --rotate normal --output DP-0 --mode 1920x1080 --pos 3840x0 --rotate normal --output DP-1 --off
      ${pkgs.nitrogen}/bin/nitrogen --restore
    '';

    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = with pkgs; (hs: [ hs.xmobar ]);

      config = import ./xmonad.hs.nix { inherit pkgs; };
    };
  };
}
