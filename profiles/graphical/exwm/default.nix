{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    xclip
    dunst
    i3lock
  ];
  services.xserver = {
    displayManager.defaultSession = "none+exwm";
    windowManager.exwm = {
      enable = true;
      package = pkgs.emacsGcc;
    };
  };
}
