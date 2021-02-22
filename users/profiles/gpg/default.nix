{
  services.gpg-agent = {
    enable = true;
    extraConfig = ''
      allow-emacs-pinentry
    '';
  };
}
