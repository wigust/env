{ lib, ... }: {
  services.openssh = {
    enable = true;
    challengeResponseAuthentication = false;
    passwordAuthentication = false;
    forwardX11 = true;
  };
  programs.ssh.extraConfig = lib.fileContents ./config;
}
