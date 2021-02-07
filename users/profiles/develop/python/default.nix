{ pkgs, ... }:
{
  home.packages =
    with pkgs.python38Packages; [
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
      pkgs.nodePackages.pyright

      pkgs.jetbrains.pycharm-professional
    ];

  home.sessionPath = [ "$PYENV_ROOT/bin" ];

  home.sessionVariables = {
    PYENV_ROOT = "$HOME/.pyenv";
    PYTHONSTARTUP = ''
            ${pkgs.writers.writePython3 "ptpython.py"
      ({
      libraries = [ pkgs.python3Packages.ptpython ];
        })
      (builtins.readFile ./ptconfig.py) }
    '';
  };
}
