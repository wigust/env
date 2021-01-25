{ pkgs, config, ... }:
{
  home.file = { };

  services.emacs = {
    enable = true;
    client.enable = true;
  };

  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./.doom.d;
    package = pkgs.emacsGcc;
  };

  home.packages = with pkgs; [
    ripgrep
    fd

    pandoc

    xclip
    samba

    ispell
    (aspellWithDicts (dicts: with dicts; [ en en-computers en-science ]))

    sqlite
  ];
}
