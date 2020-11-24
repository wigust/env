{ home, nix-darwin, lib, pkgs, self, utils, ... }:
let
  inherit (utils) recImport;
  inherit (builtins) attrValues removeAttrs;

  config = hostName:
    lib.darwinSystem {

      modules = let
        inherit (home.darwinModules) home-manager;

        core = self.darwinModules.profiles.core;

        global = {
          networking.hostName = hostName;
          nix.nixPath = let path = toString ../.;
          in [
            "nixpkgs=${pkgs.path}"
            "nixpkgs-overlays=${toString ./overlays}"
            "darwin=${inputs.nix-darwin}"
          ];

          nixpkgs = { pkgs = osPkgs; };
        };

        overrides = {
          nixpkgs.overlays = let
            override = import ../pkgs/override.nix pkgs;

            overlay = pkg: final: prev: { "${pkg.pname}" = pkg; };
          in map overlay override;
        };

        local = import "${toString ./.}/${hostName}.nix";

        # Everything in `./modules/list.nix`.
        flakeModules =
          attrValues (removeAttrs self.darwinModules [ "profiles" ]);

      in flakeModules ++ [ core global local home-manager overrides ];

    };

  hosts = recImport {
    dir = ./.;
    _import = config;
  };
in hosts
