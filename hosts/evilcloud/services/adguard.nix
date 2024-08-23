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
      filters = [
        {
          name = "AdGuard DNS filter";
          enabled = true;
          id = 1;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt";
        }
        {
          name = "AdGuard Default Blocklist";
          enabled = true;
          id = 2;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_2.txt";
        }
        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_12.txt";
          name = "Dandelion Sprout's Anti-Malware List";
          idi = 1724512503;
        }
        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt";
          name = "Malicious URL Blocklist (URLHaus)";
          id = 1724512504;
        }
        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_50.txt";
          name = "uBlock₀ filters – Badware risks";
          id = 1724512505;
        }
        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_4.txt";
          name = "Dan Pollock's List";
          id = 1724512506;
        }
        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_3.txt";
          name = "Peter Lowe's Blocklist";
          id = 1724512507;
        }
        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_18.txt";
          name = "Phishing Army";
          id = 1724512508;
        }
        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_33.txt";
          name = "Steven Black's List";
          id = 1724512509;
        }
        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_30.txt";
          name = "Phishing URL Blocklist (PhishTank and OpenPhish)";
          id = 1724512510;
        }
      ];
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