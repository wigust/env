{ pkgs, ... }:
''
  spawnXmobar = spawnPipe "${pkgs.haskellPackages.xmobar}/bin/xmobar ${./_xmobar.hs}"
''
