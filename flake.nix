{
  # nix flake update --update-input <input>
  inputs = {
    master.url = "nixpkgs/master";
    nixos.url = "nixpkgs/master";
    nixos-2003.url = "nixpkgs/nixos-20.03";
    home.url = "github:rycee/home-manager";
    emacs.url = "github:nix-community/emacs-overlay";
    hardware.url = "github:nixos/nixos-hardware";
    devshell.url = "github:numtide/devshell";
    flake-utils.url = "github:numtide/flake-utils/flatten-tree-system";
    nur.url = "github:nix-community/NUR";
    nixpkgs-darwin.url = "nixpkgs/nixpkgs-20.09-darwin";
    nix-darwin.url = "github:lnl7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "master";
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs =
    inputs@{ self
    , home
    , nixos
    , master
    , hardware
    , devshell
    , nur
    , emacs
    , flake-utils
    , nixos-2003
    , nix-darwin
    , nixpkgs-darwin
    , sops-nix
    }:
    let
      inherit (builtins) attrValues;
      inherit (flake-utils.lib) eachDefaultSystem flattenTreeSystem;
      inherit (nixos.lib) recursiveUpdate;
      inherit (self.lib) overlays modules genPackages pkgImport genHomeActivationPackages;

      externOverlays = [
        emacs.overlay
        devshell.overlay
        nur.overlay
      ];

      homeModules = [ ];

      outputs =
        {
          inherit overlays;

          nixosModules = modules "nixos";
          darwinModules = modules "darwin";

          nixosConfigurations =
            import ./hosts/nixos
              (recursiveUpdate inputs rec {
                inherit homeModules;
                inherit (pkgs) lib;
                pkgs = self.legacyPackages."x86_64-linux";
                externModules = [
                  home.nixosModules.home-manager
                  sops-nix.nixosModules.sops
                ];
                system = "x86_64-linux";
              });

          darwinConfigurations =
            import ./hosts/darwin (recursiveUpdate inputs rec {
              inherit homeModules;
              inherit (pkgs) lib;
              pkgs = self.legacyPackages."x86_64-darwin";
              externModules = [ home.darwinModules.home-manager ];
              system = "x86_64-darwin";
            });

          homeConfigurations =
            builtins.mapAttrs
              (_: config: config.config.home-manager.users)
              self.nixosConfigurations;

          overlay = import ./pkgs;

          lib = import ./lib {
            inherit (nixos) lib;
          };
        };
    in
    recursiveUpdate
      (eachDefaultSystem
        (system:
        let
          unstable = pkgImport master [
            (final: prev: {
              darwin = pkgImport nix-darwin [ ] system;
            })
          ]
            system;

          nixos-old = pkgImport nixos-2003 [ ] system;

          pkgs =
            let
              override = import ./pkgs/override.nix;
              overlays = [
                (final: prev: {
                  gstreamer = nixos-old.gstreamer;
                  gst_plugins_base = nixos-old.gst_plugins_base;
                })
                (override unstable)
                self.overlay
                (final: prev: {
                  lib = (prev.lib or { }) // {
                    inherit (nixos.lib) nixosSystem;
                    inherit (nix-darwin.lib) darwinSystem;
                    flk = self.lib;
                    utils = flake-utils.lib;
                  };
                })
              ]
              ++ (attrValues self.overlays)
              ++ externOverlays;
            in
            pkgImport nixos overlays system;

          packages =
            let
              packages' = flattenTreeSystem system
                (genPackages {
                  inherit self pkgs;
                });

              homeActivationPackages = genHomeActivationPackages
                self.homeConfigurations;
            in
            recursiveUpdate packages' homeActivationPackages;
        in
        {
          inherit packages;

          devShell = import ./shell {
            inherit pkgs nixos;
          };

          legacyPackages = pkgs;
        }
        )
      )
      outputs;
}
