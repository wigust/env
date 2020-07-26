{ config, lib, pkgs, ... }:

with lib;

let

  xcfg = config.services.xserver;
  dmcfg = xcfg.displayManager;
  cfg = dmcfg.ly;
  xEnv = config.systemd.services.display-manager.environment;

  inherit (pkgs) ly;

  xserverWrapper = pkgs.writeScript "xserver-wrapper" ''
    #!/bin/sh
    ${concatMapStrings (n: ''
      export ${n}="${getAttr n xEnv}"
    '') (attrNames xEnv)}
    exec systemd-cat -t xserver-wrapper ${dmcfg.xserverBin} ${
      toString dmcfg.xserverArgs
    } "$@"
  '';

  Xsetup = pkgs.writeScript "Xsetup" ''
    #!/bin/sh
    ${cfg.setupScript}
    ${dmcfg.setupCommands}
  '';

  Xstop = pkgs.writeScript "Xstop" ''
    #!/bin/sh
    ${cfg.stopScript}
  '';

  cfgFile = pkgs.writeText "config.ini" ''
    # animation enabled
    #animate = false
    #animate = true

    # the active animation (only animation '0' available for now)
    #animation = 0

    # the char used to mask the password
    #asterisk = *
    #asterisk = o

    # background color id
    #bg = 0

    # blank main box
    #blank_box = true

    # erase password input on failure
    #blank_password = false
    #blank_password = true

    # console path
    #console_dev = /dev/console

    # input active by default on startup
    #default_input = 2

    # foreground color id
    #fg = 9

    # remove main box borders
    #hide_borders = false
    #hide_borders = true

    # number of visible chars on an input
    #input_len = 34

    # active language
    #lang = en
    #lang = fr

    # load the saved desktop and login
    #load = true

    # main box margins
    #margin_box_h = 2
    #margin_box_v = 1

    # total input sizes
    #max_desktop_len = 100
    #max_login_len = 255
    #max_password_len = 255

    # cookie generator
    #mcookie_cmd = /usr/bin/mcookie

    # event timeout in milliseconds
    #min_refresh_delta = 5

    # default path
    #path = /sbin:/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/sbin

    # command executed when pressing F2
    #restart_cmd = /sbin/shutdown -r now

    # save the current desktop and login as defaults
    #save = true

    # file in which to save and load the default desktop and login
    #save_file = /etc/ly/save

    # service name (set to ly to use the provided pam config file)
    #service_name = ly

    # command executed when pressing F1
    #shutdown_cmd = /sbin/shutdown -a now

    # terminal reset command (tput is faster)
    #term_reset_cmd = /usr/bin/tput reset

    # tty in use
    #tty = 2

    # wayland setup command
    #wayland_cmd = /etc/ly/wsetup.sh

    # add wayland specifier to session names
    #wayland_specifier = false
    #wayland_specifier = true    systemd.services.display-manager.serviceConfig = {
      Type = "idle";
      After = ["systemd-user-sessions.service" "plymouth-quit-wait.service" "getty@tty${
        toString xcfg.tty
      }.service"];
      StandardInput = "tty";
      TTYPath = "/dev/tty${toString xcfg.tty}";
      TTYReset = true;
      TTYVHangup = true;
    };


    # wayland desktop environments
    #waylandsessions = /usr/share/wayland-sessions

    # xorg server command
    #x_cmd = /usr/bin/X

    # xorg setup command
    #x_cmd_setup = /etc/ly/xsetup.sh

    # xorg xauthority edition tool
    #xauth_cmd = /usr/bin/xauth

    # xorg desktop environments
    #xsessions = /usr/share/xsessions
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

      setupScript = mkOption {
        type = types.str;
        default = "";
        example = ''
          # workaround for using NVIDIA Optimus without Bumblebee
          xrandr --setprovideroutputsource modesetting NVIDIA-0
          xrandr --auto
        '';
        description = ''
          A script to execute when starting the display server. DEPRECATED, please
          use <option>services.xserver.displayManager.setupCommands</option>.
        '';
      };

      stopScript = mkOption {
        type = types.str;
        default = "";
        description = ''
          A script to execute when stopping the display server.
        '';
      };
    };

  };

  config = mkIf cfg.enable {
    services.xserver = {
      job.execCmd = "exec ${ly}/bin/ly -c ${cfgFile}";
      displayManager.lightdm.enable = lib.mkForce false;
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

    #environment.systemPackages = [ ly ];
    #services.dbus.packages = [ ly ];

    # To enable user switching, allow sddm to allocate TTYs/displays dynamically.
    #services.xserver.tty = null;
    # services.xserver.display = null;
  };
}
