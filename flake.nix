{
  # nix flake update --update-input <input>
  inputs = {
    master.url = "nixpkgs/master";
    nixos.url = "nixpkgs/nixos-20.09";
    home.url = "github:rycee/home-manager/release-20.09";
    emacs.url = "github:nix-community/emacs-overlay";
    hardware.url = "github:nixos/nixos-hardware";
    devshell.url = "github:numtide/devshell";
    flake-utils.url = "github:numtide/flake-utils/flatten-tree-system";
    nur.url = "github:nix-community/NUR";
    nix-doom-emacs.url = "github:vlaci/nix-doom-emacs";
  };

  outputs = inputs@{ self, home, nixos, master, emacs, hardware, devshell, nur, flake-utils, nix-doom-emacs }:
    let
      inherit (builtins) attrNames attrValues readDir elem pathExists filter;
      inherit (flake-utils.lib) flattenTreeSystem eachDefaultSystem;
      inherit (nixos) lib;
      inherit (lib) all removeSuffix recursiveUpdate genAttrs filterAttrs
        mapAttrs;
      inherit (utils) pathsToImportedAttrs overlayPaths modules genPackages pkgImport;

      utils = import ./lib/utils.nix { inherit lib; };

      externOverlays = [
        emacs.overlay
        devshell.overlay
        nur.overlay
      ];
      externModules = [ home.nixosModules.home-manager ];
      homeModules = [ nix-doom-emacs.hmModule ];

      pkgs' = unstable:
        let
          override = import ./pkgs/override.nix;
          overlays = (attrValues self.overlays)
                     ++ externOverlays
                     ++ [ self.overlay (override unstable) ];
        in
          pkgImport nixos overlays;

      unstable' = pkgImport master [ ];

      osSystem = "x86_64-linux";
      outputs =
        let
          system = osSystem;
          unstablePkgs = unstable' system;
          osPkgs = pkgs' unstablePkgs system;
        in
          {
            nixosConfigurations =
              import ./hosts (recursiveUpdate inputs {
                inherit lib osPkgs unstablePkgs system utils externModules homeModules;
              });

            homeConfigurations =
              builtins.mapAttrs
                (_: config: config.config.home-manager.users)
                self.nixosConfigurations;

            overlay = import ./pkgs;

            overlays = pathsToImportedAttrs overlayPaths;

            nixosModules = modules;
          };
    in
          recursiveUpdate
            (eachDefaultSystem
              (system:
                let
                  unstablePkgs = unstable' system;
                  pkgs = pkgs' unstablePkgs system;

                  packages = flattenTreeSystem system
                    (genPackages {
                      inherit self pkgs;
                    });
                in
                  {
                    packages = packages //
                               utils.genHomeActivationPackages
                                 self.homeConfigurations;

                    devShell = import ./shell.nix {
                      inherit pkgs;
                    };
                  }
              )
            )
            outputs;
      }
