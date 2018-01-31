{ lib, pkgs, config, ... }:
let
  inherit (pkgs.stdenv) isDarwin isLinux shell;
  inherit (lib) fileContents optionals optionalString optionalAttrs;
  bin = name:
    let package = pkgs."${name}"; in "${package}/bin/${name}";
in
{
  home.sessionVariables =
    {
      BAT_PAGER = "less";
    };

  home.file.".p10k.zsh".source = ./.p10k.zsh;

  home.packages = with pkgs; [
    bat
    bzip2
    exa
    fzf
    gitAndTools.hub
    gnused
    gzip
    less
    lrzip
    p7zip
    procs
    skim
    unrar
    unzip
    xz
    zsh-completions
  ];

  programs.zsh = {
    enable = true;

    autocd = true;
    history.size = 10000;
    enableAutosuggestions = true;

    # Available on master but not in 20.09
    # dirHashes = {
    #   dl = "$HOME/Downloads";
    #   dev = "$HOME/Development";
    # };

    shellAliases = {
      # quick cd
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";

      # git
      g = "git";

      # grep
      grep = "${pkgs.ripgrep}/bin/rg";
      gi = "grep -i";

      # internet ip
      myip = "dig +short myip.opendns.com @208.67.222.222 2>&1";

      # nix
      n = "nix";
      np = "n profile";
      ni = "np install";
      nr = "np remove";
      ns = "n search --no-update-lock-file";
      nf = "n flake";
      srch = "ns nixpkgs";
      nrb = "sudo nixos-rebuild switch --flake $HOME/env";
      nis =
        let
          nix-issues-search = pkgs.writeShellScriptBin "nix-issues-search" "${pkgs.xdg_utils}/bin/xdg-open https://github.com/NixOS/nixpkgs/issues?q=$(${pkgs.coreutils}/bin/printf \" %s\" \"$@\" | ${pkgs.jq}/bin/jq -sRr @uri)";
        in
        "${nix-issues-search}/bin/nix-issues-search";

      nps =
        let
          nix-package-search = pkgs.writeShellScriptBin "nix-package-search" "${pkgs.xdg_utils}/bin/xdg-open https://search.nixos.org/packages?query=$(${pkgs.coreutils}/bin/printf \" %s\" \"$@\" | ${pkgs.jq}/bin/jq -sRr @uri)";
        in
        "${nix-package-search}/bin/nix-package-search";
      # sudo
      s = "sudo -E ";
      si = "sudo -i";
      se = "sudoedit";

      # top
      top = bin "gotop";

      cat = bin "bat";

      df = "df -h";
      du = "du -h";

      l = "ls -lhg --git";
      la = "l -a";
      t = "l -T";
      ta = "la -T";

      ps = bin "procs";

      rz = "exec zsh";
    } // optionalAttrs isLinux {
      ls = bin "exa";
      # systemd
      ctl = "systemctl";
      stl = "s systemctl";
      utl = "systemctl --user";
      ut = "systemctl --user start";
      un = "systemctl --user stop";
      up = "s systemctl start";
      dn = "s systemctl stop";
      jtl = "journalctl";
    } // optionalAttrs isDarwin { };

    shellGlobalAliases = {
      UUID = "$(uuidgen | tr -d \\n)";
      G = "| grep";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "battery"
        "direnv"
        "docker"
        "docker-compose"
        "emacs"
        "encode64"
        "extract"
        "git"
        "github"
        "gpg-agent"
        "history"
        "history-substring-search"
        "jira"
        "pyenv"
        "python"
        "ssh-agent"
        "stack"
        "sudo"
        "systemd"
        "transfer"
        "virtualenv"
        "web-search"
        "zsh-interactive-cd"
      ] ++ optionals isDarwin [ "osx" "keychain" ];
      extraConfig = ''
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      '';
    };

    initExtra =
      ''
        eval "$(${bin "direnv"} hook zsh)"
        eval $(${pkgs.gitAndTools.hub}/bin/hub alias -s)
        ${optionalString isDarwin "eval \"$(pyenv init -)\""}
      '';
  };
}
