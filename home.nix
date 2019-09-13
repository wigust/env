{ pkgs, ... }:
let
  env = "/home/ben/Development/env";
in
{
  # Dotfiles and such
  xdg.configFile."i3blocks/config".source = "${env}/i3/i3blocks.conf";
  xdg.configFile."i3/config".source ="${env}/i3/config";

  xdg.configFile."nixpkgs/home.nix".source = "${env}/home.nix";

  home.file = {
    ".spacemacs".source = "${env}/spacemacs";
    ".zshrc".source = "${env}/zshrc";

    ".emacs.d" = {
      source = fetchGit {
       url = "https://github.com/syl20bnr/spacemacs";
       ref = "develop";
       rev = "560b51c324957cf649c72d68f4c1aa1e6a540c30";
      };
      recursive = true;
    };
  };
}
