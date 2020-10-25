self: super: {
  pyfa = self.callPackage ../packages/pyfa.nix { };
  evemon = self.callPackage ../packages/evemon.nix { };
  eve-online = self.unstable.callPackage ../packages/eve-online.nix {
    gstreamer = self.nixos-2003.gstreamer;
    gst_plugins_base = self.nixos-2003.gst_plugins_base;
  };
  unison-ucm = self.callPackage ../packages/unison.nix { };
}
