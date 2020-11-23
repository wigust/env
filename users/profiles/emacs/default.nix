{ pkgs, ... }:
let
  tangle = file:
    let
      tangled =
        pkgs.runCommand "tangle" { buildInputs = [ pkgs.emacs-nox ]; } ''
          mkdir -p $out
          cd $out
          cp ${file} .spacemacs.org
          emacs --batch -l ob-tangle --eval "(org-babel-tangle-file \".spacemacs.org\")"
          mv .spacemacs.el .spacemacs
        '';
    in "${tangled}/.spacemacs";
in {
  home.file = {
    ".emacs.d" = {
      source = pkgs.fetchFromGitHub {
        owner = "syl20bnr";
        repo = "spacemacs";
        rev = "77d84b14e057aadc6a71c536104b57c617600f35";
        sha256 = "sha256-GXhBX/nQfXX+p/G2gI1lcBwW5gxbLh4P7UzPARRjfB0=";
        fetchSubmodules = true;
      };
      recursive = true;
    };
    ".spacemacs".source = tangle ./.spacemacs.org;
  };

  home.packages = with pkgs; [
    emacs-all-the-icons-fonts

    pandoc

    xclip
    samba

    ispell
    aspell
    hunspell
    aspellDicts.en
    aspellDicts.en-computers

    sqlite

    (import ./spacemacs-with-packages.nix { inherit pkgs; } {
      layers = import ./layers.nix;
      themes = import ./themes.nix;
      emacsPackage = pkgs.emacsGcc;
      extraPackages = (epkgs: with epkgs; [ doom-themes direnv company-lsp ]);
    })
  ];
}
