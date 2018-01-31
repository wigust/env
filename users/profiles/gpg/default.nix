{ pkgs, ... }: {
  home.packages = with pkgs; [
    gnupg
    ssh-to-pgp
    pinentry-curses
  ];

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableScDaemon = true;
    pinentryFlavor = "curses";
    extraConfig = ''
      allow-emacs-pinentry
    '';
  };
}
