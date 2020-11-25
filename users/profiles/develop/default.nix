{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Utils
    less
    wget
    curl

    vscode
  ];
}
