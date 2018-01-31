{ pkgs, lib, ... }:
let
  inherit (pkgs.stdenv) isLinux;
  inherit (lib) mkIf optionals; in
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

    # IDE :(
    jetbrains.pycharm-professional
    jetbrains.jdk

    (vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions; (
        [
          haskell.haskell
          ms-azuretools.vscode-docker
          tamasfe.even-better-toml
          bbenoist.Nix
        ] ++ optionals isLinux [
          ms-python.python
          ms-vscode-remote.remote-ssh
          ms-vsliveshare.vsliveshare
        ] ++ vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "nixpkgs-fmt";
            publisher = "B4dM4n";
            version = "0.0.1";
            sha256 = "sha256-vz2kU36B1xkLci2QwLpl/SBEhfSWltIDJ1r7SorHcr8=";
          }
        ] ++ optionals isLinux [{
          name = "remote-ssh-edit";
          publisher = "ms-vscode-remote";
          version = "0.47.2";
          sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
        }]
      );
    })
  ];

  home.sessionVariables = {
    PAGER = "less";
    LESS = "-iFJMRWX -z-4 -x4";
    LESSOPEN = "|${pkgs.lesspipe}/bin/lesspipe.sh %s";
    EDITOR = "emacs";
    VISUAL = "emacs";
  };
}
