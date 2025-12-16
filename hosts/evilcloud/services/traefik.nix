{ config, ... }:
let
  cfg = config.services.traefik;
in
{
  services.traefik = {
    enable = true;
    staticConfigOptions = {
      entryPoints = {
        web = {
          address = ":80";
          http.redirections.entryPoint = {
            to = "websecure";
            scheme = "https";
            permanent = true;
          };
        };

        websecure = {
          address = ":443";
        };
      };

      certificatesResolvers = {
        letsencrypt.acme.storage = "/var/lib/traefik/certs/acme.json";
      };
      api = {
        dashboard = true;
        insecure = false;
      };
    };
  };

  systemd.tmpfiles.rules = [ "d ${cfg.dataDir}/certs 700 traefik traefik" ];
}
