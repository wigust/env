{ lib, config, ... }:
{
  users.users.root = {
    hashedPassword = config.users.users.ben.hashedPassword;
    openssh.authorizedKeys.keyFiles = config.users.users.ben.openssh.authorizedKeys.keyFiles;
  };
}
