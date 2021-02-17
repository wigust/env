{ pkgs, config, lib, ... }:
let
  inherit (pkgs.stdenv) isLinux isDarwin;
  inherit (lib) mkIf optionals;
in
{
  programs.emacs = {
    enable = true;
    package = pkgs.emacsGcc.override {
      withXwidgets = isLinux;
    };
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

  # Install MacOS applications to the user environment if the targetPlatform is Darwin
  home.file."Applications/home-manager" =
    let
      apps = pkgs.buildEnv {
        name = "home-manager-applications";
        paths = config.home.packages;
        pathsToLink = "/Applications";
      };
    in
    mkIf isDarwin {
      source = "${apps}/Applications";
    };

  home.packages = with pkgs;
    [
      # Doom dependencies
      ripgrep
      fd
      emacs-all-the-icons-fonts
      ispell
      (aspellWithDicts (dicts: with dicts; [ en en-computers en-science ]))
      xdotool
      xorg.xwininfo

      # Languages
      nodePackages.dockerfile-language-server-nodejs

      rnix-lsp
      llvm # Includes clangd
      nodePackages.bash-language-server

      sqlite
      git
    ] ++ optionals isLinux (with pkgs; [ libvterm ]);
}
