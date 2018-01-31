{ config, pkgs, ... }:
let
  builderFor = name: [
    "ssh://${name}-builder"
    "ssh-ng://${name}-builder"
  ];
in
{
  nix = {
    trustedBinaryCaches = builderFor "vigilant" ++ builderFor "witness";
    binaryCachePublicKeys = [
      "cache:gQaPRcksojpLk5iuhprIn+F8s2OpJdGx+i5SKneSkXw="
    ];
  };
  systemd.services.nix-store-sign = {
    description = "Ensure nix store is signed";
    wantedBy = [ "multi-user.target" ];

    # set this service as a oneshot job
    serviceConfig.Type = "oneshot";

    # have the job run this shell script
    script = with pkgs;''
      ${nixFlakes}/bin/nix sign-paths --all -k ${config.sops.secrets.cache_private_key.path} &
    '';
  };
}
