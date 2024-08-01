{ inputs, config, ... }:
let
  secretsPath = builtins.toString inputs.evilsecrets;
in
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
        postRun = ''
          scp -pr . root@evilcloud:/var/lib/acme/
          ssh -t root@evilcloud "chown -R acme: /var/lib/acme/evilwoods.net && systemctl restart caddy.service"
        '';
      };
    };
  };
}
