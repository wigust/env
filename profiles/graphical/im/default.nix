{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    discord-canary
    element-desktop
    signal-desktop
    slack
    mattermost
  ];
}
