{ config, lib, pkgs, ... }:

with lib; {
  services.kubernetes = {
    easyCerts = true;
    roles = [ "master" "node" ];
    masterAddress = "localhost";
  };
  services.dockerRegistry.enable = true;

  networking.firewall.allowedTCPPorts = [ 6443 ];

  environment.systemPackages = with pkgs; [ kompose kubectl ];
}
