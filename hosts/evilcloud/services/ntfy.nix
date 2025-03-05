{ config, ... }:
let
  inherit (builtins) toString;

  inherit (config.evilwoods.host.vars) legoHTTPPort;
  inherit (config.evilwoods.vars) domain;

  appName = "ntfy";
  appURL = "${appName}.${domain}";

  ntfyListenPort = ":8086";
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

    caddy.virtualHosts."${appURL}" = {
      useACMEHost = appURL;
      extraConfig = ''
        reverse_proxy localhost${ntfyListenPort}
      '';
    };
  };

  security.acme.certs."${appURL}" = {
    domain = appURL;
    listenHTTP = ":${toString legoHTTPPort}";
    reloadServices = [ "caddy.service" ];
  };
}
