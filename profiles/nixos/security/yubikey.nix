{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    yubikey-personalization-gui
    yubikey-manager-qt
    yubico-piv-tool
    yubioath-desktop
  ];

  services.udev.packages = with pkgs; [
    yubikey-personalization
  ];

  services.pcscd = {
    enable = true;
    plugins = [ pkgs.acsccid ];
  };
}
