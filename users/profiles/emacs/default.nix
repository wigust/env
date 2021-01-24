{ pkgs, ... }:
{
  home.file = {
  };

  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./.doom.d;
    package = pkgs.emacsGcc;
  };

  home.packages = with pkgs; [
    ripgrep
    emacs-all-the-icons-fonts
    fd

    pandoc

    xclip
    samba

    ispell
    aspell
    hunspell
    aspellDicts.en
    aspellDicts.en-computers

    sqlite
  ];
}
