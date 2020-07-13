{ pkgs, home, ... }:
with pkgs;
with builtins;
with lib; {
  # Dotfiles and such
  xdg.configFile."dunst/dunstrc".source = ./dotfiles/dunst/dunstrc;
  home.file = {
    ".emacs.d" = {
      source = pkgs.fetchFromGitHub {
        owner = "syl20bnr";
        repo = "spacemacs";
        rev = "c43b9ea104510a7a91ba6342b663b44737d4f716";
        sha256 = "0xara6g0fkqxp1dnwlan1kkgiwfrzkpnyf2rn44m9n8d8h72nh2n";
      };
      recursive = true;
    };
    ".spacemacs".source = ./dotfiles/.spacemacs;
    ".zshrc".source = ./dotfiles/.zshrc;
    ".gitconfig".source = ./dotfiles/.gitconfig;
    ".ssh/config".source = ./dotfiles/ssh/config;
    ".xmonad/xmobar.hs".source = ./dotfiles/xmonad/xmobar.hs;
    "desktop.sh".source = ./dotfiles/desktop.sh;
  };
}
