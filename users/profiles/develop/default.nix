{ pkgs, lib, ... }:
let
  inherit (pkgs.stdenv) isLinux;
  inherit (lib) optionals; in
{
  home.packages = with pkgs; [
    # Utils
    less
    wget
    curl
    git-crypt
    gnupg
    less
    ncdu
    pass
    tokei
    wget
    terraform_0_13
    deploy-rs
  ] ++ optionals isLinux [
    # IDE :(
    jetbrains.pycharm-professional
    jetbrains.jdk
  ];

  home.sessionVariables = {
    PAGER = "less";
    JAVA_HOME = "${pkgs.jetbrains.jdk}/bin/java";
    LESS = "-iFJMRWX -z-4 -x4";
    LESSOPEN = "|${pkgs.lesspipe}/bin/lesspipe.sh %s";
    EDITOR = "emacs";
    VISUAL = "emacs";
  };
}
