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
        buildInputs = [ pkgs.emacsGcc ];
        phases = [ "installPhase" ];
        installPhase = ''
          runHook preInstall
          cp ${file} ${inFilename}
          emacs -q --batch -l ob-tangle --eval "(org-babel-tangle-file \"${inFilename}\")"
          cp ${filename} $out
          runHook postInstall
        '';
      };
in
{
  home.file = {
    ".emacs.d/init.el".source = tangle ./.emacs.d/init.org;
  };

  programs.emacs = {
    enable = true;
    package = pkgs.emacsGcc;
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
      git
    ];
}
