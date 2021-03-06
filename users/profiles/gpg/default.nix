{ pkgs, ... }: {
  home.packages = with pkgs; [
    gnupg
    ssh-to-pgp
  ];

  services.gpg-agent = {
    enable = true;
    extraConfig = ''
      allow-emacs-pinentry
    '';
  };
}
