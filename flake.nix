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

      platforms = [ "x86_64-linux" "x86_64-darwin" ];

      forAllPlatforms = f: lib.genAttrs platforms (platform: f platform);

      pkgsFor = pkgs:
        forAllPlatforms (platform:
          import pkgs {
            system = platform;
            overlays = attrValues self.overlays ++ [ emacs.overlay ];
            config = {
              allowUnfree = true;
              # Only necessary because of hindent, shouldn`t be marked broken 
              # though as an overlay should fix this????
              allowBroken = true;
            };
          });

    in {
      nixosConfigurations = import ./hosts (recursiveUpdate inputs rec {
        inherit lib utils;
        system = "x86_64-linux";
        pkgset = {
          osPkgs = (pkgsFor nixos)."${system}";
          pkgs = (pkgsFor master)."${system}";
        };
      });

      darwinConfigurations = import ./hosts/darwin (recursiveUpdate inputs rec {
        inherit (darwin) lib utils;
        system = "x86_64-darwin";
        pkgs = (pkgsFor nixpkgs-darwin)."${system}";
      });

      devShell = forAllPlatforms (platform:
        let
          pkgs = (pkgsFor (if platform == "x86_64-darwin" then
            darwin
          else
            nixos))."${platform}";
        in pkgs.mkShell {
          nativeBuildInputs = with pkgs; [ git nixFlakes ];

          NIX_CONF_DIR = let
            current =
              pkgs.lib.optionalString (builtins.pathExists /etc/nix/nix.conf)
              (builtins.readFile /etc/nix/nix.conf);
            nixConf = pkgs.writeTextDir "etc/nix.conf" ''
              ${current}
              experimental-features = nix-command flakes
            '';
          in "${nixConf}/etc";

          shellHook = ''
            export NIX_PATH="$NIX_PATH:darwin=${inputs.darwin}"
            rebuild () {
              # _NIXOS_REBUILD_REEXEC is necessary to force nixos-rebuild to use the nix binary in $PATH
              # otherwise the initial installation would fail
              sudo --preserve-env=PATH --preserve-env=NIX_CONF_DIR _NIXOS_REBUILD_REEXEC=1 \
                nixos-rebuild "$@"
            }
          '';
        });

      overlay = import ./pkgs;

      overlays = let
        overlayDir = ./overlays;
        fullPath = name: overlayDir + "/${name}";
        overlayPaths = map fullPath (attrNames (readDir overlayDir));
      in pathsToImportedAttrs overlayPaths;

      packages = forAllPlatforms (platform:
        let
          pkgs = (pkgsFor (if platform == "x86_64-darwin" then
            darwin
          else
            nixos))."${platform}";
          packages = self.overlay pkgs pkgs;
          overlays = lib.filterAttrs (n: v: n != "pkgs") self.overlays;
          overlayPkgs = genAttrs (attrNames overlays)
            (name: (overlays."${name}" pkgs pkgs)."${name}");
        in recursiveUpdate packages overlayPkgs);

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
    };
}
