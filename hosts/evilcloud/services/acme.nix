{ config, lib, ... }:
let
  inherit (lib) mkIf mkMerge;

  inherit (config.evilwoods.vars) isTestEnv;
  # inherit (config.evilwoods.host.vars) legoHTTPPort;
  listenHTTPPort = "1360";
in
{
  config = mkMerge [
    {
      evilwoods.host.vars.legoHTTPPort = 1360;
      security.acme = {
        acceptTerms = true;
        defaults.email = "acme.kpo9e@ewmail.me";
        certs = {
          "evilwoods.net" = {
            domain = "evilwoods.net";
            listenHTTP = ":${listenHTTPPort}";
            reloadServices = [ "caddy.service" ];
          };
        };
      };

      # The tunnel is managed by cloudflare tunnel dashboard
      services.cloudflared.tunnels."5c5360ae-6911-41e2-bbcb-b5b78954349c" = {
        ingress = {
          "evilwoods.net" = "http://127.0.0.1:${listenHTTPPort}";
          "nextcloud.evilwoods.net" = {
            path = "/.well-known/acme-challenge";
            service = "http://127.0.0.1:${listenHTTPPort}";
          };
          "*.evilwoods.net" = "http://127.0.0.1:${listenHTTPPort}";
        };
      };
    }

    (mkIf isTestEnv {
      security.acme.certs.defaults.server = "https://acme-staging-v02.api.letsencrypt.org/directory";
    })
  ];
}
