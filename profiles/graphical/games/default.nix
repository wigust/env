{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    minecraft
  ];

  # S T E A M
  programs.steam.enable = true;

  # better for steam proton games
  systemd.extraConfig = "DefaultLimitNOFILE=1048576";

  # improve wine performance
  environment.sessionVariables = { WINEDEBUG = "-all"; };
}
