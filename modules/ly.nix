{ config, lib, pkgs, ... }:

with lib;

let

  xcfg = config.services.xserver;
  dmcfg = xcfg.displayManager;
  cfg = dmcfg.ly;
  xEnv = config.systemd.services.display-manager.environment;
  mk_save = cfg.defaultUser != null;
  save_file = if !mk_save then
    ""
  else
    pkgs.writeText "ly-prefs" ''
      ${cfg.defaultUser}
      ${toString cfg.defaultSessionIndex}
    '';

  inherit (pkgs) ly;

  cfgFile = pkgs.writeText "config.ini" ''
    load=${if mk_save then "true" else "false"}
    mcookie_cmd=${pkgs.utillinux}/bin/mcookie
        # An empty path variable will prevent ly from setting it
        path=
        save=false
        load=false
        save_file=${save_file}

        # service name (pam needs this set to login)
        service_name=login

        shutdown_cmd=${pkgs.systemd}/bin/systemctl poweroff
        restart_cmd=${pkgs.systemd}/bin/systemctl reboot
        term_reset_cmd=${pkgs.ncurses6}/bin/tput reset
        tty=${toString xcfg.tty}

        x_cmd=${dmcfg.xserverBin}
        x_cmd_setup=${dmcfg.setupCommands}
        xauth_cmd = ${dmcfg.xauthBin}
        xsessions=${dmcfg.sessionData.desktops}/share/xsessions

        ${cfg.extraConfig}
      '';

  autoLoginSessionName = dmcfg.sessionData.autologinSession;

in {
  options = {

    services.xserver.displayManager.ly = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable ly as the display manager.
        '';
      };

      defaultUser = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "login";
        description = ''
          The default user to load. If you put a username here you
          get it automatically loaded into the username field, and
          the focus is placed on the password.
        '';
      };

      defaultSessionIndex = mkOption {
        type = lib.types.ints.unsigned;
        default = 0;
        example = 1;
        description = ''
          Index of the default session to load. This session will be
          preselected.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        example = ''
          [Autologin]
          User=john
          Session=plasma.desktop
        '';
        description = ''
          Extra lines appended to the configuration of SDDM.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    services.xserver = {
      displayManager = {
        job.execCmd = "exec ${ly}/bin/ly -c ${cfgFile}";
        lightdm.enable = lib.mkForce false;
      };
    };

    systemd.services.display-manager.serviceConfig = {
      Type = "idle";
      After = [
        "systemd-user-sessions.service"
        "plymouth-quit-wait.service"
        "getty@tty${toString xcfg.tty}.service"
      ];
      StandardInput = "tty";
      TTYPath = "/dev/tty${toString xcfg.tty}";
      TTYReset = true;
      TTYVHangup = true;
    };

    environment.systemPackages = [ ly ];
    services.dbus.packages = [ ly ];
  };
}
