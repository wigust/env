{ unstableModulesPath, ... }: {
  imports = [
    ../users/ben
    ../../profiles/nixos/network
    "${unstableModulesPath}/installer/cd-dvd/iso-image.nix"
  ];

  isoImage.makeEfiBootable = true;
  isoImage.makeUsbBootable = true;
}
