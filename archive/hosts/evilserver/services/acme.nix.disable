{ config, lib, ... }:
let
  inherit (lib) mkIf mkMerge;

  isTestEnv = config.evilwoods.vars.isTestEnv;
in
{
  config = mkMerge [
    {
      sops.secrets."acme-cloudflare.env" = {
        mode = "0400";
        owner = config.users.users.acme.name;
        group = config.users.users.acme.group;
      };

      security.acme = {
        acceptTerms = true;
        defaults.email = "acme.kpo9e@ewmail.me";
        certs = {
          "evilwoods.net" = {
            domain = "evilwoods.net";
            extraDomainNames = [ "*.evilwoods.net" ];
            dnsProvider = "cloudflare";
            dnsPropagationCheck = true;
            environmentFile = config.sops.secrets."acme-cloudflare.env".path;
            reloadServices = [ "caddy.service" ];
          };
        };
      };
    }

    (mkIf isTestEnv {
      security.acme.certs."evilwoods.net".server =
        "https://acme-staging-v02.api.letsencrypt.org/directory";
    })
  ];
}
