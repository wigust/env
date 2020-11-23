{
  description = "A highly structured configuration database.";

  inputs = {
    master.url = "nixpkgs/master";
    nixos.url = "nixpkgs/nixos-unstable";
    home.url = "github:rycee/home-manager/release-20.09";
    emacs.url = "github:nix-community/emacs-overlay";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-20.09-darwin";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs-darwin";
  };

  outputs = inputs@{ self, home, nixos, master, emacs, darwin, nixpkgs-darwin }:
    let
      inherit (builtins) attrNames attrValues readDir;
      inherit (nixos) lib;
      inherit (lib) removeSuffix recursiveUpdate genAttrs filterAttrs;
      inherit (utils) pathsToImportedAttrs;

      utils = import ./lib/utils.nix { inherit lib; };

      system = "x86_64-linux";

      pkgImport = pkgs:
        import pkgs {
          inherit system;
          overlays = attrValues self.overlays ++ [ emacs.overlay ];
          config = {
            allowUnfree = true;
            # Only necessary because of hindent, shouldn`t be marked broken 
            # though as an overlay should fix this????
            allowBroken = true;
          };
        };

      pkgset = {
        osPkgs = pkgImport nixos;
        pkgs = pkgImport master;
      };
      eeee = "a";

    in with pkgset; {
      nixosConfigurations = import ./hosts
        (recursiveUpdate inputs { inherit lib pkgset system utils; });

      darwinConfigurations = import ./hosts/darwin (recursiveUpdate inputs {
        inherit (darwin) lib utils;
        pkgs = pkgImport nixpkgs-darwin;
      });

      devShell."${system}" = import ./shell.nix { inherit pkgs; };

      overlay = import ./pkgs;

      overlays = let
        overlayDir = ./overlays;
        fullPath = name: overlayDir + "/${name}";
        overlayPaths = map fullPath (attrNames (readDir overlayDir));
      in pathsToImportedAttrs overlayPaths;

      packages."${system}" = let
        packages = self.overlay osPkgs osPkgs;
        overlays = lib.filterAttrs (n: v: n != "pkgs") self.overlays;
        overlayPkgs = genAttrs (attrNames overlays)
          (name: (overlays."${name}" osPkgs osPkgs)."${name}");
      in recursiveUpdate packages overlayPkgs;

      nixosModules = let
        # binary cache
        cachix = import ./cachix.nix;
        cachixAttrs = { inherit cachix; };

        # modules
        moduleList = import ./modules/list.nix;
        modulesAttrs = pathsToImportedAttrs moduleList;

        # profiles
        profilesList = import ./profiles/list.nix;
        profilesAttrs = { profiles = pathsToImportedAttrs profilesList; };

      in recursiveUpdate (recursiveUpdate cachixAttrs modulesAttrs)
      profilesAttrs;

      templates.flk.path = ./.;
      templates.flk.description = "flk template";

      defaultTemplate = self.templates.flk;
    };
}
