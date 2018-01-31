{ config, pkgs, ... }: {
  services.gitlab = {
    enable = true;
    packages.gitlab = pkgs.gitlab-ee;
    host = "git.busc.dev";
    https = true;
    initialRootEmail = "ben@busc.dev";
  };

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts."${config.services.gitlab.host}" = {
      enableACME = true;
      forceSSL = true;
      locations."/".proxyPass = "http://unix:/run/gitlab/gitlab-workhorse.socket";
    };
  };
}
