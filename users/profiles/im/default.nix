{ pkgs, lib, ... }: 
let
  inherit (pkgs) stdenv;
in 
with lib;
{
  home.packages = with pkgs; [
    element-desktop
    mattermost
  ] ++ optionals stdenv.isLinux [discord-canary signal-desktop slack];
}
