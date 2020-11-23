{ config, ... }: {
  services.syncthing = {
    enable = true;
    user = "ben";
    dataDir = "${config.users.users.ben.home}/.syncthing";
  };
}
