{ pkgs, config, lib, ... }:
{
  programs.emacs = {
    enable = true;
    package = pkgs.emacsGcc;
    extraPackages = epkgs: [ epkgs.vterm ];
  };
  home.sessionPath = [ "$HOME/.emacs.d/bin" ];
  home.sessionVariables = {
    EMACS = "${config.programs.emacs.finalPackage}/bin/emacs";
  };

  home.file = {
    ".doom.d/" = {
      source = ./.doom.d;
      recursive = true;
      # onChange = ''
      #   #!${pkgs.stdenv.shell}
      #   DOOM="$HOME/.emacs.d"

      #   if [ ! -d "$DOOM" ]; then
      #     git clone https://github.com/hlissner/doom-emacs.git $DOOM
      #     $DOOM/bin/doom -y install
      #   fi

      #   $DOOM/bin/doom sync
      # '';
    };
  };

  home.packages = with pkgs;
    [
      # Doom dependencies
      ripgrep
      fd
      emacs-all-the-icons-fonts
      ispell
      (aspellWithDicts (dicts: with dicts; [ en en-computers en-science ]))

      # Languages
      nodePackages.dockerfile-language-server-nodejs

      rnix-lsp
      llvm # Includes clangd
      nodePackages.bash-language-server

      sqlite
      git

      libvterm
    ];
}
