{ pkgs, emacs, ... }: {
  imports = [
    ../../users/work
  ];
  environment.shells = with pkgs; [ zsh ];
  programs.zsh.enable = true;
  nixpkgs.overlays = [
    emacs.overlay
  ];
  networking.hostName = "bbuscarino";
}
