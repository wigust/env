{ pkgs, lib, ... }:
let
  inherit (pkgs.stdenv) isDarwin isLinux;
  inherit (lib) optionals optionalAttrs;
in
{
  home.packages =
    with pkgs; with python38Packages; [
      (pkgs.python38Full.withPackages (p:
        with p; [
          setuptools
          pip
          virtualenv
          tkinter
          ptpython
        ]))
      poetry
      black
      nodePackages.pyright
    ] ++ optionals isLinux [ jetbrains.pycharm-professional ];

  home.sessionPath = optionals isDarwin [ "$PYENV_ROOT/bin" ];

  home.sessionVariables = {
    PYTHONSTARTUP = pkgs.writers.writePython3 "ptpython.py"
      ({
        libraries = [ pkgs.python3Packages.ptpython ];
      })
      (builtins.readFile ./ptconfig.py);
  } // optionalAttrs isDarwin {
    PYENV_ROOT = "$HOME/.pyenv";
  };
}
