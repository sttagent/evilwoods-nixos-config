{ config, ... }:
let
  inherit (builtins) toString;

  inherit (config.evilwoods.host.vars) legoHTTPPort;
in
{
  services = {
    ntfy-sh = {
      enable = true;
      settings = {
        listen-http = ":8086";
        base-url = "https://ntfy.evilwoods.net";
      };
    };

    caddy.virtualHosts."ntfy.evilwoods.net" = {
      useACMEHost = "ntfy.evilwoods.net";
      extraConfig = ''
        reverse_proxy localhost:8086
      '';
    };
  };

  security.acme.certs."ntfy.evilwoods.net" = {
    domain = "ntfy.evilwoods.net";
    listenHTTP = ":${toString legoHTTPPort}";
    reloadServices = [ "caddy.service" ];
  };
}
