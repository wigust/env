{ unstableModulesPath, pkgs, ... }: {
  imports = [
    "${unstableModulesPath}/installer/cd-dvd/installation-cd-graphical-kde.nix"
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  services.pcscd.enable = true;
  services.udev.packages = with pkgs; [ yubikey-personalization ];

  environment.systemPackages = with pkgs; [ gnupg pinentry-curses pinentry-qt paperkey wget ];

  programs = {
    ssh.startAgent = false;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  isoImage.makeEfiBootable = true;
  isoImage.makeUsbBootable = true;
}
