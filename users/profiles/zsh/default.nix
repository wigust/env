{ lib, pkgs, ... }:
let
  inherit (builtins) concatStringsSep;

  inherit (lib) fileContents;

in {

  home.sessionVariables = let fd = "${pkgs.fd}/bin/fd -H";
  in {
    BAT_PAGER = "less";
    SKIM_ALT_C_COMMAND = let
      alt_c_cmd = pkgs.writeScriptBin "cdr-skim.zsh" ''
        #!${pkgs.zsh}/bin/zsh
        ${fileContents ./cdr-skim.zsh}
      '';
    in "${alt_c_cmd}/bin/cdr-skim.zsh";
    SKIM_DEFAULT_COMMAND = fd;
    SKIM_CTRL_T_COMMAND = fd;
  };

  home.packages = with pkgs; [
    bat
    bzip2
    exa
    gitAndTools.hub
    gzip
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

    # enableGlobalCompInit = false;

    history.size = 10000;

    dirHashes = {
      nixos = "/etc/nixos";
      dl = "$HOME/Downloads";
      dev = "$HOME/Development";
    };

    shellAliases = {
      cat = "${pkgs.bat}/bin/bat";

      df = "df -h";
      du = "du -h";

      ls = "exa";
      l = "ls -lhg --git";
      la = "l -a";
      t = "l -T";
      ta = "la -T";

      ps = "${pkgs.procs}/bin/procs";

      rz = "exec zsh";
    };

    initExtra = let
      sources = with pkgs; [
        ./cdr.zsh
        "${skim}/share/skim/completion.zsh"
        "${oh-my-zsh}/share/oh-my-zsh/plugins/sudo/sudo.plugin.zsh"
        "${oh-my-zsh}/share/oh-my-zsh/plugins/extract/extract.plugin.zsh"
        "${zsh-you-should-use}/share/zsh/plugins/you-should-use/you-should-use.plugin.zsh"
        "${zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
        "${zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh"
      ];

      source = map (source: "source ${source}") sources;
      setOptions = [
        "extendedglob"
        "incappendhistory"
        "sharehistory"
        "histignoredups"
        "histfcntllock"
        "histreduceblanks"
        "histignorespace"
        "histallowclobber"
        "autocd"
        "cdablevars"
        "nomultios"
        "pushdignoredups"
        "autocontinue"
        "promptsubst"
      ];
      functions = pkgs.stdenv.mkDerivation {
        name = "zsh-functions";
        src = ./functions;

        ripgrep = "${pkgs.ripgrep}";
        man = "${pkgs.man}";
        exa = "${pkgs.exa}";

        installPhase = let basename = "\${file##*/}";
        in ''
          mkdir $out

          for file in $src/*; do
            substituteAll $file $out/${basename}
            chmod 755 $out/${basename}
          done
        '';
      };

      plugins = concatStringsSep "\n" ([
        "${pkgs.any-nix-shell}/bin/any-nix-shell zsh --info-right | source /dev/stdin"
      ] ++ source);

    in ''
      ${plugins}
      setopt ${concatStringsSep " " setOptions}

      fpath+=( ${functions} )
      autoload -Uz ${functions}/*(:t)

      # useful functions
      autoload -Uz zmv zcalc zargs url-quote-magic bracketed-paste-magic
      zle -N self-insert url-quote-magic
      zle -N bracketed-paste bracketed-paste-magic


      if [[ -f ~/.zcompdump ]]; then
        typeset -i updated_at=$(date +'%j' -r ~/.zcompdump \
          || stat -f '%Sm' -t '%j' ~/.zcompdump)

        # save time if completion cache has been update recently
        if [ $(date +'%j') != $updated_at ]; then
          compinit -u
        else
          compinit -C
        fi
      else
        compinit -C
      fi

      # Case insens only when no case match; after all completions loaded
      zstyle ':completion:*' matcher-list \
        "" 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

      # Auto rehash for new binaries
      zstyle ':completion:*' rehash true

      # remove duplicates from paths
      typeset -U path
      typeset -U fpath

      # keep shell state frozen
      ttyctl -f

      eval "$(${pkgs.starship}/bin/starship init zsh)"
      eval "$(${pkgs.direnv}/bin/direnv hook zsh)"
      eval $(${pkgs.gitAndTools.hub}/bin/hub alias -s)
      source ${pkgs.skim}/share/skim/key-bindings.zsh
    '';
  };
}
