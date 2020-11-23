{ pkgs, ... }:
let
  inherit (builtins) readFile;
  inherit (pkgs) writeScript;
in
''
  ${readFile ./_xmonad.hs}
  ${import ./_xmonad.nix {
    inherit pkgs;
    }}
''
