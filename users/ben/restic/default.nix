{ lib, pkgs, config, ... }:
{
  environment.systemPackages = with pkgs; [
    # storj
    rclone
    restic
  ];

  services.restic.backups = {
    tardigrade =
      let
        home = config.users.users.ben.home;
      in
      {
        paths = [
          "${home}/sync/"
          "${home}/backups/"
          "${home}/Desktop"
          "${home}/Documents"
          "${home}/Downloads"
          "${home}/Music"
          "${home}/Pictures"
          "${home}/Videos"
        ];
        repository = "rclone:waterbear:backups/backups";
        initialize = true;
        passwordFile = config.sops.secrets.restic_password.path;
        rcloneConfigFile = config.sops.secrets.rclone_conf.path;
        timerConfig = {
          OnBootSec = "5m";
          OnCalendar = "weekly";
        };
      };
  };
}
