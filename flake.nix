{
  # nix flake update --update-input <input>
  inputs = {
    master.url = "nixpkgs/master";
    nixos.url = "nixpkgs/master";
    home.url = "github:rycee/home-manager";
    emacs.url = "github:nix-community/emacs-overlay";
    hardware.url = "github:nixos/nixos-hardware";
    devshell.url = "github:numtide/devshell";
    flake-utils.url = "github:numtide/flake-utils/flatten-tree-system";
    nur.url = "github:nix-community/NUR";
    nixpkgs-darwin.url = "nixpkgs/nixpkgs-20.09-darwin";
    nix-darwin.url = "github:lnl7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "master";
  };

  outputs = inputs@{ self, home, nixos, master, hardware, devshell, nur, emacs, flake-utils, nix-darwin, nixpkgs-darwin }:
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
                externModules = [ home.nixosModules.home-manager ];
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

            pkgs =
              let
                override = import ./pkgs/override.nix;
                overlays = [
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
