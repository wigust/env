{ unstableModulesPath, ... }: {
  imports = [
    ../users/ben
    ../profiles/network
    "${unstableModulesPath}/installer/cd-dvd/iso-image.nix"
  ];

  isoImage.makeEfiBootable = true;
  isoImage.makeUsbBootable = true;
}
