{ home
, lib
, nix-darwin
, master
, pkgs
, self
, system
, externModules
, homeModules
, emacs
, ...
}:
let
  inherit (lib.flk) recImport;
  inherit (builtins) attrValues removeAttrs;

  unstableModules = [ ];

  config = hostName:
    lib.darwinSystem rec {
      specialArgs =
        {
          inherit emacs;
          unstableModulesPath = "${master}/modules";
        };

      modules =
        let
          core = self.darwinModules.profiles.core;

          modOverrides = { config, unstableModulesPath, ... }: {
            disabledModules = unstableModules;
            imports = map
              (path: "${unstableModulesPath}/${path}")
              unstableModules;
          };
          hm-as-super = { config, ... }: {
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

            networking.hostName = lib.mkDefault hostName;
            nix.nixPath = let path = toString ../.; in
              [
                "nixos-unstable=${master}"
                "nixpkgs=${nix-darwin}"
                "nixpkgs-overlays=${path}/overlays"
                "home-manager=${home}"
              ];

            nixpkgs.config = pkgs.config;
          };

          local = import "${toString ./.}/${hostName}.nix";

          # Everything in `./modules/list.nix`.
          flakeModules =
            attrValues (removeAttrs self.darwinModules [ "profiles" ]);

        in
        flakeModules ++ [
          core
          global
          local
          hm-as-super
          modOverrides
        ] ++ externModules;

    };

  hosts = recImport {
    dir = ./.;
    _import = config;
  };
in
hosts
