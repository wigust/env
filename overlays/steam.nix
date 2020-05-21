self: super:

let
  master = import (super.fetchFromGitHub {
    owner = "nixos";
    repo = "nixpkgs";
    rev = "5445b8d8d09b4fde038fc71b2178d68a82a884e7";
    sha256 = "0srjn633dzcx5m3rhy65wmialp97fkx65h0zjlgrgkpfwivbnmsd";
  }) { config.allowUnfree = true; };
in { steam = master.steam; }
