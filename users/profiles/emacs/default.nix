{ pkgs, config, lib, ... }:
{
  services.emacs = {
    enable = true;
    client.enable = true;
  };

  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./.doom.d;
    emacsPackage = pkgs.emacsGcc;
  };

  home.packages = with pkgs;
    [
      ripgrep
      fd

      emacs-all-the-icons-fonts

      pandoc

      xclip
      samba

      ispell
      (aspellWithDicts (dicts: with dicts; [ en en-computers en-science ]))

      sqlite
      git
    ];
}
