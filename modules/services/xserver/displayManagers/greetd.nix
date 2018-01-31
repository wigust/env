{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.services.greetd;
  greeters = [ "gtkgreet" "dlm" "tuigreet" ];

in
{
  options.services.greetd = {
    enable = mkEnableOption "greetd login manager";

    vt = mkOption {
      type = types.int;
      default = 1;
      defaultText = "1";
      description = ''
        The VT to run the greeter on.
      '';
    };

    command = mkOption {
      type = with types; nullOr str;
      default = null;
      description = ''
        Command greetd will execute to start the greeter.
        Let it be null if you want default commands.
      '';
      example = "cage -s -- gtkgreet";
    };

    greeter = {
      agreety.enable = mkEnableOption "agreety";
      gtkgreet.enable = mkEnableOption "gtkgreet";
      dlm.enable = mkEnableOption "dlm";
      tuigreet.enable = mkEnableOption "tuigreet";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = (length (filter (v: cfg.greeter.${v}.enable) greeters)) <= 1;
        message = ''
          Multiple greeters can't be enabled at the same time.
        '';
      }
    ];

    services.greetd.greeter.agreety.enable = mkIf
      (all (v: !cfg.greeter.${v}.enable) (tail greeters))
      (mkDefault true);

    environment.etc."greetd/config.toml" = {
      source = (pkgs.formats.toml { }).generate "config.toml" {
        terminal = {
          inherit (cfg) vt;
        };

        default_session = {
          command =
            if cfg.command == null then {
              agreety = "agreety --cmd top";
              gtkgreet = "cage -s -- gtkgreet";
              dlm = "dlm --cmd $SHELL";
              tuigreet = "tuigreet --cmd $SHELL";
            }.${
            head (filter (v: cfg.greeter.${v}.enable) greeters)
            } else cfg.command;

          user = "root";
        };
      };
    };

    systemd.services."greetd" = {
      enable = true;
      after = [
        "systemd-user-sessions.service"
        "plymouth-quit-wait.service"
        "getty@tty${toString cfg.vt}.service"
      ];

      conflicts = [
        "getty@tty${toString cfg.vt}.service"
      ];

      wantedBy = [
        "multi-user.target"
      ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.greetd}/bin/greetd";
        IgnoreSIGPIPE = "no";
        SendSIGHUP = "yes";
        TimeoutStopSec = "30s";
        KeyringMode = "shared";
        Restart = "always";
        RestartSec = 1;
        StartLimitBurst = 5;
        StartLimitInterval = 30;
      };
    };

    /*
      security.pam.services.greetd.text = ''
      auth       required     pam_securetty.so
      auth       requisite    pam_nologin.so
      auth       include      system-local-login
      account    include      system-local-login
      session    include      system-local-login
      '';
    */

    environment.systemPackages = with pkgs; [
      greetd
      tuigreet
      dlm
      gtkgreet
      cage
    ];
  };
}
