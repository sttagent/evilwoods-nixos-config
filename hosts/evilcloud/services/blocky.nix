{
  services = {
    blocky = {
      enable = true;
      # TODO: use block lists
      settings = {
        upstreams = {
          groups.default = [ "1.1.1.1" ];
        };
        ports = {
          dns = ":53";
        };
        customDNS = {
          mapping = {
            "evilserver.tail" = "100.100.53.98";
            "evilserver.lan" = "192.168.1.101";
          };
        };
      };
    };
  };
}
