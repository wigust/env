{ pkgs, config, lib, ... }:
let
  tangle = file:
    let
      inFilename = baseNameOf file;
      filename = "${lib.removeSuffix ".org" inFilename}.el";
    in
    pkgs.stdenv.mkDerivation
      {
        name = filename;
        buildInputs = [ emacs ];
        phases = [ "installPhase" ];
        installPhase = ''
          runHook preInstall
          cp ${file} ${inFilename}
          emacs -q --batch -l ob-tangle --eval "(org-babel-tangle-file \"${inFilename}\")"
          cp ${filename} $out
          runHook postInstall
        '';
      };
  tangled = tangle ./.emacs.d/init.org;
  emacs = (pkgs.emacsPackagesGen pkgs.emacsGcc).emacsWithPackages (epkgs: [ epkgs.use-package ]);
  straight = pkgs.nix-straight {
    emacsPackages = pkgs.emacsPackagesFor emacs;
    emacsInitFile = tangled;
    emacsArgs = [
      "--"
      "install"
    ];
  };
  fmt = {
    reset = ''\\033[0m'';
    bold = ''\\033[1m'';
    red = ''\\033[31m'';
    green = ''\\033[32m'';
  };
  emacsEnv = straight.emacsEnv {
    straightDir = "$out/straight";
    packages = straight.packageList (super: {
      phases = [ "installPhase" ];
      preInstall = ''
        # Fix gccEmacs
        export HOME=$(mktemp -d)
      '';
      postInstall = ''
        # If gccEmacs or anything would write in $HOME, fail the build.
        if [[ -z "$(find $HOME -maxdepth 0 -empty)" ]]; then
          printf "${fmt.red}${fmt.bold}ERROR:${fmt.reset} "
          printf "${fmt.red}doom-emacs build resulted in files being written in "'$HOME'" of the build sandbox.\n"
          printf "Contents of "'$HOME'":\n"
          find $HOME
          printf ${fmt.reset}
          exit 33
        fi
      '';
    });
  };
in
{
  home.file = {
    ".emacs.d" = {
      source = emacsEnv;
      recursive = true;
    };
  };

  services.emacs = {
    enable = true;
    client.enable = true;
  };

  programs.emacs = {
    enable = true;
    package = emacs;
  };

  home.packages = with pkgs;
    [
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
