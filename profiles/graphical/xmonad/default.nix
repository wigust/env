{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    farbfeld
    xss-lock
    imgurbash2
    maim
    xclip
    xorg.xdpyinfo
    dunst
  ];

  services.xserver.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
    extraPackages = with pkgs; (hs: [ hs.xmobar ]);

    config = import ./xmonad.hs.nix { inherit pkgs; };
  };
}
