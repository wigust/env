{ home
, lib
, nixos
, master
, pkgs
, self
, system
, hardware
, externModules
, homeModules
, ...
}:
let
  inherit (lib.flk) recImport;
  inherit (builtins) attrValues removeAttrs;
  inherit (lib) traceVal;

  unstableModules = [ ];

  config = hostName:
    lib.nixosSystem rec {
      inherit system;

      specialArgs =
        {
          hardware = hardware.nixosModules;
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
                  inherit homeModules;
                  # Allow accessing the parent NixOS configuration.
                  super = config;
                };
              });
            };
          };
          global = {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            hardware.enableRedistributableFirmware = lib.mkDefault true;

            networking.hostName = hostName;
            nix.nixPath = let path = toString ../.; in
              [
                "nixos-unstable=${master}"
                "nixpkgs=${nixos}"
                "nixpkgs-overlays=${path}/overlays"
                "home-manager=${home}"
              ];

            nixpkgs = { inherit pkgs; };

            nix.registry = {
              master.flake = master;
              nixflk.flake = self;
              nixpkgs.flake = nixos;
              home-manager.flake = home;
            };

            system.configurationRevision = lib.mkIf (self ? rev) self.rev;
            system.stateVersion = "20.09";
          };

          local = import "${toString ./.}/${hostName}.nix";

          # Everything in `./modules/list.nix`.
          flakeModules =
            attrValues (removeAttrs self.nixosModules [ "profiles" ]);

        in
        flakeModules ++ [
          core
          global
          local
          hm-nixos-as-super
          modOverrides
        ] ++ externModules;

    };

  hosts = recImport {
    dir = ./.;
    _import = config;
  };
in
hosts
