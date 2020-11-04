{ pkgs, home, ... }:
with pkgs;
with builtins;
with lib; {
  # Dotfiles and such
  xdg.configFile."dunst/dunstrc".source = ./dotfiles/dunst/dunstrc;
  home.file = {
    ".emacs.d" = {
      source = pkgs.fetchFromGitHub {
        owner = "syl20bnr";
        repo = "spacemacs";
        rev = "ab52131d9859bb9346da7473ff9672309f0ead5d";
        sha256 = "sha256-l/j/pICqkY841DnYFLfYRSVnnFccVS/uM3Y5C7MMrzI=";
        fetchSubmodules = true;
      };
      recursive = true;
    };
    ".spacemacs".source = ./dotfiles/.spacemacs;
    ".gitconfig".source = ./dotfiles/.gitconfig;
    ".ssh/config".source = ./dotfiles/ssh/config;
    ".xmonad/xmobar.hs".source = ./dotfiles/xmonad/xmobar.hs;
  };
  programs.git.extraConfig = {
    "filter \"lfs\"" = {
      clean = "${pkgs.git-lfs}/bin/git-lfs clean -- %f";
      smudge = "${pkgs.git-lfs}/bin/git-lfs smudge --skip -- %f";
      process = "${pkgs.git-lfs}/bin/git-lfs filter-process --skip";
      required = true;
    };
  };

  programs.direnv = {
    enable = true;
    stdlib = ''
      use_flake() {
        mkdir -p $(direnv_layout_dir)
        watch_file flake.nix
        watch_file flake.lock
        eval "$(nix print-dev-env --profile "$(direnv_layout_dir)/flake-profile")"
      }
    '';
  };
}
