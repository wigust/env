final: prev:
let
  ignoringVulns = x: x // { meta = (x.meta // { knownVulnerabilities = [ ]; }); };
in
{
  uplink = final.callPackage ./uplink.nix { };
  pyenv = final.callPackage ./pyenv.nix { };
  #vmware = final.callPackage ./vmware.nix {};
  eve-online = final.callPackage ./eve-online.nix {
    openssl_1_0_2 = prev.openssl_1_0_2.overrideAttrs ignoringVulns;
  };
}
