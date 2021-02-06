{ pkgs, config, lib, ... }:
{
  programs.doom-emacs = {
    # TODO: Fix when nix-doom-emacs is fixed
    #enable = true;
    #doomPrivateDir = ./.doom.d;
    #emacsPackage = pkgs.emacsGit;
    #extraPackages = epkgs: [ epkgs.vterm ];
  };

  programs.emacs = {
    enable = true;
    package = pkgs.emacsGcc;
    extraPackages = epkgs: [ epkgs.vterm ];
  };

  home.sessionVariables.PATH = [ "$HOME/.emacs.d/bin:$PATH" ];

  home.file = {
    ".doom.d/" = {
      source = ./.doom.d;
      recursive = true;
      onChange = ''
        #!${pkgs.stdenv.shell}
        DOOM="$HOME/.emacs.d"

        if [ ! -d "$DOOM" ]; then
          git clone https://github.com/hlissner/doom-emacs.git $DOOM
          $DOOM/bin/doom -y install
        fi

        $DOOM/bin/doom sync
      '';
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
      nodePackages.pyright
      nodePackages.dockerfile-language-server-nodejs

      # purescript
      nodePackages.purescript-language-server
      purs
      spago
      pulp
      purty
      purp

      haskellPackages.haskell-language-server
      rnix-lsp
      llvm # Includes clangd
      nodePackages.bash-language-server

      sqlite
      git

      libvterms
    ];
}
