{ config, ... }:
let
  inherit (config.evilwoods.base) domain;

  appName = "ntfy";
  appURL = "${appName}.${domain}";

  ntfyListenPort = ":8081";
in
{
  services = {
    ntfy-sh = {
      enable = true;
      settings = {
        listen-http = ntfyListenPort;
        base-url = "https://${appURL}";
      };
    };

    traefik.dynamicConfigOptions.http = {
      routers.${appName} = {
        rule = "Host(`${appURL}`)";
        service = "${appName}";
        entryPoints = "websecure";
        tls.certResolver = "letsencrypt";
      };
      services.${appName}.loadBalancer.servers = [
        { url = "http://localhost${ntfyListenPort}"; }
      ];
    };
  };
}
