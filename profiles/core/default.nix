{ config, lib, pkgs, ... }: {

  imports = [ ../../local/locale.nix ];

  environment = {
    systemPackages = with pkgs; [
      binutils
      coreutils
      curl
      direnv
      dnsutils
      dosfstools
      fd
      git
      gotop
      gptfdisk
      iputils
      jq
      moreutils
      nmap
      ripgrep
      utillinux
      whois
    ];

  };

  fonts = {
    fontDir.enable = true;
    enableDefaultFonts = true;
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
    ];
    fontconfig.defaultFonts = {

      monospace = [ "DejaVu Sans Mono Nerd Font Complete Mono" ];

      sansSerif = [ "DejaVu Sans" ];

    };
  };

  nix = {
    autoOptimiseStore = true;
    gc.automatic = true;
    optimise.automatic = true;

    useSandbox = true;

    allowedUsers = [ "@wheel" ];

    trustedUsers = [ "root" "@wheel" ];

    extraOptions = ''
      experimental-features = nix-command flakes ca-references
      min-free = 536870912
    '';

  };

  security = {

    hideProcessInformation = true;

    protectKernelImage = true;

  };

  services.earlyoom.enable = true;

  users.mutableUsers = false;

}
