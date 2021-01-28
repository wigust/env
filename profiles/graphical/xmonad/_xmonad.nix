{ pkgs, ... }:
let
  xmobarconf = pkgs.runCommand "xmobar.hs"
    {
      icons = pkgs.fetchFromGitHub
        {
          owner = "jumper149";
          repo = "xpm-status-icons";
          rev = "9648462dc04fe801d3cba80cde80c686a4182012";
          hash = "sha256-a4iWzi2Y/CtUzit5ESDagskaYXLTGF3ahtk9RnFyRSc=";
        };
      backlight = pkgs.writeScriptBin "backlight" ''
        #!${pkgs.stdenv.shell}
        bri="$(${pkgs.xorg.xbacklight}/bin/xbacklight -get)"
        icon=""
        ${pkgs.coreutils}/bin/printf "%s %.0f" "$icon" "$(xbacklight -get)"
      '';
      battery = pkgs.writeScriptBin "battery" ''
        #!${pkgs.stdenv.shell}
        cap="$(${pkgs.coreutils}/bin/cat /sys/class/power_supply/BAT1/capacity)"
        status="$(${pkgs.coreutils}/bin/cat /sys/class/power_supply/BAT1/status)"
        estimated="$(${pkgs.acpi}/bin/acpi -b | ${pkgs.gnugrep}/bin/grep -E 'remaining|until' | ${pkgs.gawk}/bin/awk '{print $5}')"
        if [ $status = "Charging" ]; then 
           icon=""
               if [ $cap -ge 85 ] ;then
               notify-send "battery $cap"
            fi
        fi
        if [ $status = "Discharging" ]; then
            icon=""
        fi
        ${pkgs.coreutils}/bin/printf "%s %s (%s)" "$icon" "$cap" "$estimated"
      '';
      clock = pkgs.writeScriptBin "clock" ''
        #!${pkgs.stdenv.shell}
        date="$(${pkgs.coreutils}/bin/date +"%a %b %d %l:%M %p"| sed 's/  / /g')"
        icon=""
        ${pkgs.coreutils}/bin/printf "%s %s" "$icon" "$date"
      '';
      cpu = pkgs.writeScriptBin "cpu" ''
        #!${pkgs.stdenv.shell}
        clock="$(${pkgs.coreutils}/bin/cat /proc/cpuinfo | ${pkgs.gawk}/bin/awk '/MHz/ {print $4;exit;}')"
        temp="$(sensors | ${pkgs.gawk}/bin/awk '/Core 0/ {print substr($3,2)}')"
        load="$(${pkgs.coreutils}/bin/uptime | ${pkgs.gawk}/bin/awk -F'[a-z]:' '{ print $2}' | cut -d' ' -f 2 | cut -d',' -f 1)"
        ${pkgs.coreutils}/bin/printf "  %s %.0f MHz %s" "$load" "$clock" "$temp"
      '';
      internet = pkgs.writeScriptBin "internet" ''
        #!${pkgs.stdenv.shell}
        wifistatus="$(${pkgs.coreutils}/bin/cat /sys/class/net/w*/operstate)"
        ethstatus="$(${pkgs.coreutils}/bin/cat /sys/class/net/enp7s0/operstate)"
        if [ $wifistatus = "up" ]; then 
            essid="$(${pkgs.networkmanager}/bin/nmcli c | ${pkgs.gnused}/bin/sed -n '2{p;q}' | ${pkgs.gawk}/bin/awk '{print $1}')"
            quality="$(${pkgs.coreutils}/bin/cat /proc/net/wireless |  ${pkgs.gnused}/bin/sed -n '3{p;q}' | ${pkgs.gawk}/bin/awk '{printf "%.0f\n",$3}')"
            icon=""
        elif [ $ethstatus = "up" ]; then
            essid="$(${pkgs.networkmanager}/bin/nmcli c | ${pkgs.gnused}/bin/sed -n '2{p;q}' | ${pkgs.gawk}/bin/awk '{print $5}')"
            quality=""
            icon=""
        elif [ -d /sys/class/net/enp0s* ]; then
            essid="$(${pkgs.networkmanager}/bin/nmcli c | ${pkgs.gnused}/bin/sed -n '2{p;q}' | ${pkgs.gawk}/bin/awk '{print $5}')"
            quality=""
            icon=""
        else
            essid="Disconnected"
            quality=""
            icon=""
        fi
        ${pkgs.coreutils}/bin/printf "%s %s %s" "$icon" "$essid" "$quality"
      '';
      memory = pkgs.writeScriptBin "memory" ''
        #!${pkgs.stdenv.shell}
        mem=$(${pkgs.procps}/bin/free -m | ${pkgs.gnused}/bin/sed -n '2{p;q}' | ${pkgs.gawk}/bin/awk '{print $3}')
        icon=""
        ${pkgs.coreutils}/bin/printf "%s %s MB" "$icon" "$mem"
      '';
      updates = pkgs.writeScriptBin "updates" ''
        #!${pkgs.stdenv.shell}

      '';
      volume = pkgs.writeScriptBin "volume" ''
        #!${pkgs.stdenv.shell}
        vol="$(${pkgs.alsaUtils}/bin/amixer get Master | ${pkgs.coreutils}/bin/tail -n1 | ${pkgs.gnused}/bin/sed -r 's/.*\[(.*)%\].*/\1/')"
        mute="$(${pkgs.alsaUtils}/bin/amixer get Master | ${pkgs.coreutils}/bin/tail -n1 | ${pkgs.gnused}/bin/sed -r 's/.*\[(.*)\].*/\1/')"
        if [ $mute = off ]; then
            ${pkgs.coreutils}/bin/printf "ﱝ M"
        else    
            ${pkgs.coreutils}/bin/printf " %s"  "$vol"
        fi
      '';
    } "substituteAll ${./_xmobar.hs} $out";
in
''
  -- Default terminal to use
  myTerminal :: String
  myTerminal = "${pkgs.hyper}/bin/hyper"

  spawnXmobar = spawnPipe "${pkgs.haskellPackages.xmobar}/bin/xmobar ${xmobarconf}"
''
