{
  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/master";
    home-manager.url = "github:nix-community/home-manager";
    nixos-2003.url = "github:nixos/nixpkgs/nixos-20.03";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, nixos-2003 }:
    let
      inherit (builtins) attrNames attrValues;
      system = "x86_64-linux";
      pkgImport = pkgs:
        import pkgs {
          inherit system;
          config = { allowUnfree = true; };
        };
    in {
      nixosConfigurations.witness = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ({ ... }: {
            nixpkgs.overlays = [
              (final: prev: {
                unstable = (pkgImport nixpkgs-unstable);
                nixos-2003 = (pkgImport nixos-2003);
              })
            ];
          })
          ./machines/witness.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.ben = import ./home.nix;
          }
        ];
      };
    };
}
