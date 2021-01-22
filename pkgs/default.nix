final: prev: {
  uplink = final.callPackage ./uplink.nix { };
  ormolu = final.callPackage ./ormolu.nix { };
  # ly = final.callPackage ./ly.nix { };
}
