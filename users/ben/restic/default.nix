{ lib, pkgs, config, ... }:
{
  environment.systemPackages = with pkgs; [ uplink rclone restic ];

  services.restic2.backups = {
    remote =
      let
        home = config.users.users.ben.home;
      in
      {
        paths = [
          "${home}/sync/"
          "${home}/Desktop"
          "${home}/Documents"
          "${home}/Downloads"
          "${home}/Music"
          "${home}/Pictures"
          "${home}/Videos"
          "${home}/Development"
        ];
        repository = "rclone:waterbear:backups/backups";
        initialize = true;
        passwordFile = toString ../../ben/ben.hashedPassword;
        rcloneConfigFile = ./rclone.conf;
        dynamicFilesFrom = path: "(cd ${path} && (${pkgs.ag}/bin/ag /.+/ -l | ${pkgs.gawk}/bin/awk '{print \"${path}/\" $0}'))";
        timerConfig = {
          OnBootSec = "5m";
          OnCalendar = "daily";
        };
      };
  };
}
