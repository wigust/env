{ lib, config, pkgs, hardware, ... }:
{

  imports = with hardware; [
    ../users/ben
    ../profiles/graphical/games
    ../profiles/graphical
    ../profiles/graphical/xmonad
    # Hardware
    common-pc
    common-pc-ssd
    common-gpu-nvidia
    common-cpu-amd
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
    kernelModules = [ "kvm-amd" "nvidia" ];
    supportedFilesystems = [ "ntfs" ];
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
  hardware.nvidia.prime.offload.enable = false;

  services.xserver.displayManager.sessionCommands = ''
      ${pkgs.xorg.xrandr}/bin/xrandr --output DVI-D-0 --primary --mode 1920x1080 --pos 1920x0 --rotate normal --output HDMI-0 --mode 1920x1080 --pos 0x0 --rotate normal --output DP-0 --mode 1920x1080 --pos 3840x0 --rotate normal --output DP-1 --off
      ${pkgs.nitrogen}/bin/nitrogen --set-auto=${../assets/wallpaper.png} --head=0
      ${pkgs.nitrogen}/bin/nitrogen --set-auto=${../assets/wallpaper.png} --head=1
      ${pkgs.nitrogen}/bin/nitrogen --set-auto=${../assets/wallpaper.png} --head=2
    '';
}
