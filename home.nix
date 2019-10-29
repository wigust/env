{ pkgs, ... }:
with import <nixpkgs> {};
with builtins;
with lib;
let
  env = "/home/ben/env";
  fontAwesomePro = stdenv.mkDerivation {
    name = "FontAwesome-Pro";
    src = fetchGit {
      name = "font-awesome-pro";
      url = "git@github.com:FortAwesome/Font-Awesome-Pro.git";
      rev = "ad98aa363b555d05ae380fcfa38ee7f2fe7013b4";
    };
    installPhase = ''
       install -m444 -Dt $out/share/fonts/opentype {fonts,otfs}/*.otf
    '';
  };
in
{
  # Dotfiles and such
  xdg.configFile."i3status/config".source = "${env}/dotfiles/i3/i3status.conf";
  xdg.configFile."dunst/dunstrc".source = "${env}/dotfiles/dunstrc";
  xdg.configFile."i3/config".source ="${env}/dotfiles/i3/config";
  xdg.configFile."i3/desktop.sh".source ="${env}/dotfiles/i3/desktop.sh";

  xdg.configFile."ranger/rifle.conf".source = "${env}/dotfiles/ranger/rifle.conf";
  xdg.configFile."ranger/commands.py".source = "${env}/dotfiles/ranger/commands.py";
  xdg.configFile."ranger/commands_full.py".source = "${env}/dotfiles/ranger/commands_full.py";
  xdg.configFile."ranger/rc.conf".source = "${env}/dotfiles/ranger/rc.conf";
  xdg.configFile."ranger/scope.sh".source = "${env}/dotfiles/ranger/scope.sh";

  xdg.configFile."nixpkgs/home.nix".source = "${env}/home.nix";
  xdg.configFile."Code/User/settings.json".source = "${env}/dotfiles/vscode.json";

  home.packages = [fontAwesomePro];

  home.file = {
    ".spacemacs".source = "${env}/dotfiles/spacemacs";
    ".zshrc".source = "${env}/dotfiles/zshrc";
    ".gitconfig".source = "${env}/dotfiles/gitconfig";
    
    ".emacs.d" = {
      source = fetchGit {
       url = "https://github.com/syl20bnr/spacemacs";
       ref = "develop";
       rev = "f7530767722cdbab46144a275f74f04786eb559c";
      };
      recursive = true;
    };
  };
}
