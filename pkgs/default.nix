final: prev: {
  uplink = final.callPackage ./uplink.nix { };
  pyenv = final.callPackage ./pyenv.nix { };
  # ly = final.callPackage ./ly.nix { };
}
