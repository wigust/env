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
    straight.url = "github:bbuscarino/nix-straight.el";
    straight.flake = false;
  };

  outputs = inputs@{ self, home, nixos, master, emacs, hardware, devshell, nur, flake-utils, straight }:
    let
      inherit (builtins) attrValues;
      inherit (flake-utils.lib) eachDefaultSystem flattenTreeSystem;
      inherit (nixos.lib) recursiveUpdate;
      inherit (self.lib) overlays nixosModules genPackages pkgImport genHomeActivationPackages;

      externOverlays = [
        emacs.overlay
        devshell.overlay
        nur.overlay
      ];
      externModules = [ home.nixosModules.home-manager ];
      homeModules = [ ];

      outputs =
        let
          system = "x86_64-linux";
          pkgs = self.legacyPackages.${system};
        in
        {
          inherit nixosModules overlays;

          nixosConfigurations =
            import ./hosts
              (recursiveUpdate inputs {
                inherit pkgs externModules system homeModules;
                inherit (pkgs) lib;
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
                    nix-straight = import straight;
                  })
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

            packages = flattenTreeSystem system
              (genPackages {
                inherit self pkgs;
              });
          in
          {
            packages = packages //
              genHomeActivationPackages
                self.homeConfigurations;

            devShell = import ./shell {
              inherit pkgs nixos;
            };

            legacyPackages = pkgs;
          }
        )
      )
      outputs;
}
