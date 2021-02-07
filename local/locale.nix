{ pkgs, lib, ... }:
let
  inherit (pkgs) stdenv;
  inherit (lib) mkIf;
in
{
  time.timeZone = "America/New_York";
} #// (if stdenv.isLinux then {i18n.defaultLocale = "en_US.UTF-8";} else {})
