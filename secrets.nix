{ lib, sopsModule, ... }: {
  imports = [
    sopsModule
  ];

  sops = {
    defaultSopsFile = ./secrets.yaml;
    secrets = lib.genAttrs [
      "tailscale_key"
      "cache_private_key"
      "rclone_conf"
      "yeet"
      "restic_password"
      "gitconfig_home"
      "gitconfig_work"
      "synthetic_conf"
    ] (_: {});
  };
}
