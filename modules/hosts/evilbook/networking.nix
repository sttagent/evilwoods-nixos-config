{ inputs, ... }:
{
  den.aspects.evilbook.nixos =
    { host, config, ... }:
    {
      services.resolved = {
        enable = false;
        settings.Resolve = {
          Domains = [ "~." ];
          DNSOverTLS = true;
          DNSSEC = true;
          DNS = "76.76.2.22#27aq5r8yhzg.dns.controld.com";
        };
      };

      networking = {
        hostName = host.name;
        wireless.iwd.enable = true;

        networkmanager = {
          wifi.backend = "iwd";
        };
      };
    };
}
