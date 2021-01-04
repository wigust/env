{ lib, config, pkgs, hardware, ... }: {

  imports = [
    ../users/ben
    ../profiles/graphical
    ../profiles/graphical/xmonad
  ];

  boot = {
    loader = {
      grub = {
        enable = true;
        version = 2;
        device = "/dev/nvme0n1";
      };
    };
    initrd.availableKernelModules =
      [ "nvme" "xhci_pci" "ahci" "usbhid" "sd_mod" "exfat" ];
    kernelModules = [ "kvm-amd" ];
    supportedFilesystems = [ ];
  };
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/cc55a8e5-9b2f-4562-bdf8-5efdaa1a7f68";
    fsType = "ext4";
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/2bbdeb41-6a64-4341-a04f-a3f01cbe812a"; }];

  fileSystems."/mnt/windows" = {
    device = "/dev/disk/by-uuid/4E3604C83604B34F";
    fsType = "ntfs";
    options = [ "rw" "uid=${toString config.users.users.ben.uid}" ];
  };

  nix.maxJobs = lib.mkDefault 16;
  environment.systemPackages = with pkgs; [ mesa ];
  services.xserver.videoDrivers = [ "mesa" ];
}
