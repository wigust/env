final: prev:
let
  ignoringVulns = x: x // { meta = (x.meta // { knownVulnerabilities = [ ]; }); };
in
{
  uplink = final.callPackage ./uplink.nix { };
  pyenv = final.callPackage ./pyenv.nix { };
  eve-online = final.callPackage ./eve-online.nix rec {
    steam = final.steam.override { extraPkgs = pkgs: [ openssl_1_0_2 pkgs.libxml2 pkgs.openldap ]; nativeOnly = true; };
    openssl_1_0_2 = prev.openssl_1_0_2.overrideAttrs ignoringVulns;
  };
}
