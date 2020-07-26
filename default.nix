{ pkgs ? import <nixpkgs> { config.allowUnfree = true; } }:
let hls = version: (import .  /packages/hls.nix) { inherit pkgs version; };
in {
  witness = import <nixpkgs/nixos/tests/make-test-python.nix> ({ ... }: {
    name = "witness-test";

    machine = ./machines/witness.nix;

    testScript = ''
      # Just try and start the server for now
      start_all()
      witness.wait_for_unit("multi-user.target")
    '';
  });
  hls-865 = hls "8.6.5";
  hls-883 = hls "8.8.3";
  hls-8101 = hls "8.10.1";
}
