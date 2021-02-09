{ config, lib, pkgs, ... }: {
  imports = [ ../../../local/locale.nix ];
  environment.pathsToLink = [ "/share/zsh" ];
  environment = {
    systemPackages = with pkgs; with darwin.apple_sdk; [
      binutils
      coreutils
      curl
      direnv
      dnsutils
      dosfstools
      fd
      git
      gotop
      jq
      moreutils
      nmap
      ripgrep
      whois
      # Yeah
      frameworks.Security
      frameworks.CoreFoundation
      frameworks.CoreServices
    ];
    shellAliases = {
      rebuild = "noglob sudo darwin-rebuild switch --flake $HOME/env#work";
    };
  };
  services.nix-daemon.enable = true;
  fonts = {
    enableFontDir = true;
    fonts = with pkgs; [
      corefonts
      font-awesome-ttf
      fira-code
      fira-code-symbols
      jetbrains-mono
      siji
      noto-fonts
      powerline-fonts
      dejavu_fonts
      nerdfonts
      #hack-font
    ];
  };

  services.emacs = {
    enable = true;
    package = pkgs.emacsGcc;
  };

  nix = {

    gc.automatic = true;
    gc.user = "bbuscarino";
    useSandbox = true;
    package = pkgs.nixFlakes;
    buildCores = lib.mkDefault 4;

    allowedUsers = [ "nix" ];

    trustedUsers = [ "root" "nix" ];

    extraOptions = ''
      experimental-features = nix-command flakes ca-references
      min-free = 536870912
    '';

  };
}
