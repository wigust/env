{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    xclip
    dunst
  ];
  services.xserver = {
    displayManager.defaultSession = "none+xmonad";

    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = with pkgs; (hs: [ hs.xmobar ]);

      config = import ./xmonad.hs.nix { inherit pkgs; };
    };
  };
}
