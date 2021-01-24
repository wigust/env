final: prev: {
  uplink = final.callPackage ./uplink.nix { };
  # ly = final.callPackage ./ly.nix { };
} // (import ./ormolu.nix final prev )
