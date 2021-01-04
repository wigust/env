{ pkgs, ... }:
let inherit (pkgs) python3Packages;
in
{
  home.packages =
    let
      packages = pythonPackages:
        with pythonPackages; [
          setuptools
          pip
          virtualenv
          tkinter
          ptpython
        ];

      python = pkgs.python38Full.withPackages packages;
    in
    with pkgs.python38Packages; [ python poetry black python-language-server ];
  home.sessionVariables = {
    PYTHONSTARTUP =
      let
        startup = pkgs.writers.writePython3 "ptpython.py"
          {
            libraries = with python3Packages; [ ptpython ];
          } ''
          from __future__ import unicode_literals

          from pygments.token import Token

          from ptpython.layout import CompletionVisualisation

          import sys

          ${builtins.readFile ./ptconfig.py}

          try:
              from ptpython.repl import embed
          except ImportError:
              print("ptpython is not available: falling back to standard prompt")
          else:
              sys.exit(embed(globals(), locals(), configure=configure))
        '';
      in
      "${startup}";
  };
}
