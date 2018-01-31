{ config, ... }: {
  services.syncthing = {
    enable = true;
    user = "ben";
    dataDir = "${config.users.users.ben.home}/.syncthing";
  };
  networking.extraHosts = ''
    ${config.services.syncthing.guiAddress} syncthing.local
  '';
}
