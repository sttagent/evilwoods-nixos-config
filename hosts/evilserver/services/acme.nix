{ inputs, config, ... }:
let
  secretsPath = builtins.toString inputs.evilsecrets;
in 
{
  sops.secrets."acme-cloudflare.env" = {};

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
