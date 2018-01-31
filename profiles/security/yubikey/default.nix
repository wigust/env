{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    yubikey-personalization-gui
    yubikey-manager-qt
  ];

  services.udev.packages = with pkgs; [
    yubikey-personalization
  ];

  services.pcscd.enable = true;
}
