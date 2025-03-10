{ config, ... }:
let
  inherit (builtins) toString;

  inherit (config.evilwoods.vars) domain;
  inherit (config.evilwoods.host.vars) dataPath legoHTTPPort;

  appName = "immich";
  appUrl = "${appName}.${domain}";
  mediaLocation = "${dataPath}/immich";
  immichPort = config.services.immich.port;
in
{
  systemd.tmpfiles.rules = [
    "d ${mediaLocation} 0755 immich immich"
  ];

  services.immich = {
    enable = true;
    inherit mediaLocation;
    machine-learning.enable = false;
    settings = {
      server.externalDomain = "https://${appUrl}";
    };
  };

  services.caddy.virtualHosts.${appUrl} = {
    useACMEHost = appUrl;
    extraConfig = ''
      reverse_proxy localhost:${toString immichPort}
    '';
  };

  security.acme.certs.${appUrl} = {
    domain = appUrl;
    listenHTTP = ":${toString legoHTTPPort}";
    reloadServices = [ "caddy.service" ];
  };

}
