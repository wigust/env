{ pkgs, ... }: {
  home.packages = with pkgs; [ flutter dart android-studio ];
}
