{ pkgs, ... }: {
  home.packages = with pkgs; [
    chromium
    libreoffice
    gnucash
    # Media
    spotify
    # Utilities
    gnome3.networkmanagerapplet
  ];
}
