final: prev:
let
  ignoringVulns = x: x // { meta = (x.meta // { knownVulnerabilities = [ ]; }); };
in
{
  storj = final.callPackage ./storj.nix { };
  pyenv = final.callPackage ./pyenv.nix { };
  # eve-online = final.callPackage ./eve-online.nix rec {
  #   steam = final.steam.override { extraPkgs = pkgs: [ openssl_1_0_2 pkgs.libxml2 pkgs.openldap ]; nativeOnly = true; };
  #   openssl_1_0_2 = prev.openssl_1_0_2.overrideAttrs ignoringVulns;
  # };
  fetchFromSourcehut = final.callPackage ./build-support/fetchsrht { };
  dlm = final.callPackage ./os-specific/linux/dlm { };
  greetd = final.callPackage ./os-specific/linux/greetd { };
  gtkgreet = final.callPackage ./os-specific/linux/gtkgreet { };
  tuigreet = final.callPackage ./os-specific/linux/tuigreet { };
}
