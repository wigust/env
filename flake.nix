{
  # nix flake update --update-input <input>
  inputs = {
    # master.url = "nixpkgs/master";
    master.url = "github:r-ryantm/nixpkgs?rev=e24036c9a02f9ed138655e3a269b97eb8942fad5";
    nixos.url = "nixpkgs/nixos-unstable";
    home.url = "github:rycee/home-manager";
    emacs.url = "github:nix-community/emacs-overlay";
    hardware.url = "github:nixos/nixos-hardware";
    devshell.url = "github:numtide/devshell";
    flake-utils.url = "github:numtide/flake-utils/flatten-tree-system";
    nur.url = "github:nix-community/NUR";
    doom-emacs.url = "github:vlaci/nix-doom-emacs/fix-gccemacs";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-20.09-darwin";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs-darwin";
  };

  outputs = inputs@{ self, home, nixos, master, emacs, hardware, devshell, nur, flake-utils, doom-emacs, darwin, nixpkgs-darwin }:
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

      homeModules = [ doom-emacs.hmModule ];

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
            unstable = pkgImport master [ ] system;

            pkgs =
              let
                override = import ./pkgs/override.nix;
                overlays = [
                  (override unstable)
                  self.overlay
                  (final: prev: {
                    lib = (prev.lib or { }) // {
                      inherit (nixos.lib) nixosSystem;
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
