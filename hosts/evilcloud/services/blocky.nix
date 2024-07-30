{
  services = {
    blocky = {
      enable = true;
      # TODO: use block lists
      settings = {
        upstreams = {
          groups = {
            default = [
              # Clooudlare
              "tcp-tls:1.1.1.1:853"
              "tcp-tls:1.0.0.1:853"

              # Quad9
              "tcp-tls:dns.quad9.net"

              # Google
              "tcp-tls:8.8.8.8:853"

              # dns0.eu
              "tcp-tls:dns0.eu"
            ];
          };
        };
        blocking = {
          blackLists = {
            ads = [
              "https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt"
              "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
              "https://raw.githubusercontent.com/AdguardTeam/FiltersRegistry/master/filters/filter_15_DnsFilter/filter.txt"
            ];
          };
          clientGroupsBlock = {
            default = [
              "ads"
            ];
          };
        };
        ports = {
          dns = ":53";
          http = ":8053";
        };
        customDNS = {
          mapping = {
            "dns.evilwoods.net" = "100.124.137.46";
            "kitchenowl.evilwoods.net" = "100.100.53.98";
            "evilserver.tail" = "100.100.53.98";
            "evilserver.lan" = "192.168.1.101";
            "evilcloud.tail" = "100.124.137.46";
          };
        };
        bootstrapDns = [
          "tcp-tls:1.1.1.1:853"
          "tcp-tls:1.0.0.1:853"
          "tcp-tls:8.8.8.8:853"
          "tcp-tls:8.8.4.4:853"
        ];
      };
    };
  };
}
