{ pkgs, ... }: {
  home.packages = with pkgs; [
    discord-canary
    element-desktop
    signal-desktop
    slack
    mattermost
  ];
}
