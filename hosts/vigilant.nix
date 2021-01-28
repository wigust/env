{ lib, config, pkgs, hardware, ... }: {

  imports = with hardware; [
    ../profiles/graphical
    ../profiles/graphical/xmonad
    ../profiles/network
    ../users/ben
    # Hardware
    common-cpu-amd
    common-pc
    common-pc-ssd
    lenovo-thinkpad-t14s
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_5_10;
    # Turn on magical sysrq key for magic
    kernel.sysctl."kernel.sysrq" = 1;
    tmpOnTmpfs = true;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd.availableKernelModules =
      [ "nvme" "ehci_pci" "xhci_pci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
    kernelModules = [ "kvm-amd" ];
  };
  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/b92f846d-ef46-497c-96b8-50082e84e282";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/AE33-365C";
      fsType = "vfat";
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/4eed79ae-0676-4f69-a27e-1f503993869b"; }];

  nix.maxJobs = lib.mkDefault 16;
  environment.systemPackages = with pkgs; [ mesa ];
  services.xserver.videoDrivers = [ "mesa" ];

  programs.light.enable = true;
  services.actkbd = {
    enable = true;
    bindings =
      let
        increment = 5;
      in
      [
        # Brightness
        { keys = [ 224 ]; events = [ "key" ]; command = "${pkgs.light}/bin/light -U ${toString increment}"; }
        { keys = [ 225 ]; events = [ "key" ]; command = "${pkgs.light}/bin/light -A ${toString increment}"; }
      ];
  };
}
