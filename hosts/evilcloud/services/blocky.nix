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
              "1.1.1.1"
              "1.0.0.1"

              # Quad9
              "9.9.9.9"
              "149.112.112.112"

              # Google
              "8.8.8.8"
              "8.8.4.4"

              # OpenDNS
              "208.67.222.222"
              "208.67.220.220"
            ];
          };
        };
        ports = {
          dns = ":53";
        };
        customDNS = {
          mapping = {
            "evilserver.tail" = "100.100.53.98";
            "evilserver.lan" = "192.168.1.101";
            "evilcloud.tail" = "100.124.137.46";
          };
        };
      };
    };
  };
}
