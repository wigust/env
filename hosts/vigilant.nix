{ lib, config, pkgs, hardware, ... }: {

  imports = [
    ../users/ben
    ../profiles/graphical
    ../profiles/graphical/xmonad
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEFIVariables = true;
    };
    initrd.availableKernelModules =
      [ "nvme" "ehci_pci" "xhci_pci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
    kernelModules = [ "kvm-amd" ];
    supportedFilesystems = [ ];
  };
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/b92f846d-ef46-497c-96b8-50082e84e282";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/AE33-365C";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/4eed79ae-0676-4f69-a27e-1f503993869b"; }
    ];

  nix.maxJobs = lib.mkDefault 16;
  environment.systemPackages = with pkgs; [ mesa ];
  services.xserver.videoDrivers = [ "mesa" ];
}
