{ home
, lib
, nixos
, master
, pkgset
, self
, system
, utils
, hardware
, externModules
, ...
}:
let
  inherit (utils) recImport;
  inherit (builtins) attrValues removeAttrs;
  inherit (pkgset) osPkgs unstablePkgs;
  inherit (lib) traceVal;

  unstableModules = [ ];

  config = hostName:
    lib.nixosSystem rec {
      inherit system;

      specialArgs =
        {
          unstableModulesPath = "${master}/nixos/modules";
        };

      modules =
        let
          core = self.nixosModules.profiles.core;

          modOverrides = { config, unstableModulesPath, ... }: {
            disabledModules = unstableModules;
            imports = map
              (path: "${unstableModulesPath}/${path}")
              unstableModules;
          };
          hm-nixos-as-super = { config, ... }: {
            # Submodules have merge semantics, making it possible to amend
            # the `home-manager.users` submodule for additional functionality.
            options.home-manager.users = lib.mkOption {
              type = lib.types.attrsOf (lib.types.submoduleWith {
                modules = [ ];
                # Makes specialArgs available to Home Manager modules as well.
                specialArgs = specialArgs // {
                  # Allow accessing the parent NixOS configuration.
                  super = config;
                };
              });
            };
          };
          global = {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            networking.hostName = hostName;
            nix.nixPath = let path = toString ../.; in
              [
                "nixos-unstable=${master}"
                "nixpkgs=${nixos}"
                "nixos-config=${path}/configuration.nix"
                "nixpkgs-overlays=${path}/overlays"
                "home-manager=${home}"
              ];

            nixpkgs.pkgs = osPkgs;

            nix.registry = {
              master.flake = master;
              nixflk.flake = self;
              nixpkgs.flake = nixos;
              home-manager.flake = home;
            };

            system.configurationRevision = lib.mkIf (self ? rev) self.rev;
            system.stateVersion = "20.09";
          };

          overrides = {
            nixpkgs.overlays =
              let
                override = import ../pkgs/override.nix unstablePkgs;

                overlay = pkg: final: prev: {
                  "${pkg.pname}" = pkg;
                };
              in
              map overlay override;
          };

          local = import "${toString ./.}/${hostName}.nix";

          localHardware =
            let
              hardwarePath = "${toString ./.}/${hostName}.hardware.nix";
            in
            if builtins.pathExists hardwarePath then import hardwarePath { hardware = hardware.nixosModules; } else [ ];

          # Everything in `./modules/list.nix`.
          flakeModules =
            attrValues (removeAttrs self.nixosModules [ "profiles" ]);

        in
        flakeModules ++ [
          core
          global
          local
          hm-nixos-as-super
          overrides
          modOverrides
        ] ++ externModules ++ localHardware;

    };

  hosts = recImport {
    dir = ./.;
    _import = config;
  };
in
hosts
