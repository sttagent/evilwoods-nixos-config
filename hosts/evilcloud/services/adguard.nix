{
  services.adguardhome = {
    enable = true;
    host = "127.0.0.1";
    settings = {
      dns = {
        upstream_dns = [
          "https://unfiltered.adguard-dns.com/dns-query"
          "https://dns.nextdns.io"
          "https://dns.cloudflare.com/dns-query"
          "https://dns.mullvad.net/dns-query"
          "https://freedns.controld.com/p0"
          "https://dns.quad9.net/dns-query"
          "https://doh.libredns.gr/dns-query"
        ];
        ratelimit_whitelist = [
          "100.109.91.8"
          "46.162.126.31"
        ];
        refuse_any = true;
      };
      filtering = {
        protection_enabled = true;
        filtering_enabled = true;
        safebrowsing_enabled = true;
        rewrites = [
          {
            domain = "dns.evilwoods.net";
            answer = "100.124.137.46";
          }
          
          {
            domain = "*.evilwoods.net";
            answer = "100.100.53.98";
          }
          {
            domain = "evilserver.lan";
            answer = "192.168.1.101";
          }
        ];
      };
    };
  };
  
  networking.firewall = {
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [ 53 ];
  };
}