import <nixpkgs/nixos/tests/make-test-python.nix> ({ ... }:

  {
    name = "witness-test";

    machine = ./machines/witness.nix;

    testScript = ''
      # Just try and start the server for now
      start_all()
      machine.wait_for_unit("multi-user.target")
    '';

  })
