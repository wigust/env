{ pkgs, ... }: {
  home.packages = with pkgs; [
    chromium
    libreoffice
    gnucash
    # Media
    spotify
    # Utilities
    gnome3.networkmanagerapplet
    # Keyboard
    xdotool
    xbindkeys
  ];

  home.file.".xbindkeysrc".text = ''
  "${pkgs.xdotool}/bin/xdotool key alt+ctrl+shift"
    Caps_Lock
  '';
}
