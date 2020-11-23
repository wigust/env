{ pkgs, ... }: {
  imports = [ ./zsh ./python ];

  environment.shellAliases = { e = "$EDITOR"; };
  environment.variables = { };
  environment.sessionVariables = {
    "_JAVA_AWT_WM_NONREPARENTING" = "1";
    PAGER = "less";
    LESS = "-iFJMRWX -z-4 -x4";
    LESSOPEN = "|${pkgs.lesspipe}/bin/lesspipe.sh %s";
    EDITOR = "emacs";
    VISUAL = "emacs";
  };

  environment.systemPackages = with pkgs; [
    clang
    git-crypt
    gnupg
    less
    ncdu
    pass
    tokei
    wget

    # IDEs and editors
    # (
    #   let
    #     extensions = (with vscode-extensions; [
    #       bbenoist.Nix
    #       ms-vsliveshare.vsliveshare
    #       ms-python.python
    #       ms-azuretools.vscode-docker
    #       ms-vscode-remote.remote-ssh
    #     ]) ++ vscode-utils.extensionsFromVscodeMarketplace [
    #       {
    #         name = "remote-ssh-edit";
    #         publisher = "ms-vscode-remote";
    #         version = "0.47.2";
    #         sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
    #       }
    #     ];
    #   in
    #   vscode-with-extensions.override { vscodeExtensions = extensions; }
    # )
    vscode
    jetbrains.idea-ultimate
    jetbrains.rider
    jetbrains.datagrip
    jetbrains.pycharm-professional
    jetbrains.mps
    jetbrains.jdk
  ];

  documentation.dev.enable = true;
}
