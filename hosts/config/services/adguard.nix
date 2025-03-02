{
  services.adguardhome = {
    enable = true;
    host = "192.168.1.3";
    settings = {
      language = "en";
      theme = "auto";
      dns = {
        bind_host = [ "0.0.0.0" ];
        port = 53;
        enable_dnssec = true;
        aaaa_disabled = true;
        bootstrap_dns = [
          "1.1.1.1"
          "1.0.0.1"
          "94.140.14.14"
          "94.140.15.15"
        ];
        cache_size = 100000;
        cache_optimistic = true;

        upstream_dns = [
          "https://unfiltered.adguard-dns.com/dns-query"
          "https://dns.nextdns.io"
          "https://dns.cloudflare.com/dns-query"
          "https://dns.mullvad.net/dns-query"
          "https://freedns.controld.com/p0"
          "https://dns.quad9.net/dns-query"
          "https://doh.libredns.gr/dns-query"
        ];
        ratelimit = 0;
        ratelimit_whitelist = [
          "100.68.177.122"
          "46.162.126.31"
        ];
        refuse_any = true;
        allowed_clients = [
          "100.64.0.0/10"
          "192.168.1.0/24"
        ];
      };
      dhcp = {
        enabled = true;
        interface_name = "enp6s18";
        dhcpv4 = {
          gateway_ip = "192.168.1.1";
          subnet_mask = "255.255.255.0";
          range_start = "192.168.1.100";
          range_end = "192.168.1.254";
        };
      };

      # TODO: block smart TVs telemetry
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
        safe_search = {
          enabled = true;
          youtube = false;
        };
        rewrites = [
          {
            domain = "*.evilwoods.net";
            answer = "100.80.252.66";
          }
          {
            domain = "*.lan.evilwoods.net";
            answer = "192.168.1.4";
          }
        ];
      };
    };
  };

  networking.firewall = {
    extraInputRules = ''
      ip saddr 192.168.1.4 tcp dport 3000 accept
    '';
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [
      53
      67
      68
    ];
  };
}
