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
          dns = "100.100.53.98:53";
        };
        customDNS = {
          mapping = {
            "evilwoods.tail" = "100.100.53.98";
            "evilwoods.lan" = "192.168.1.101";
          };
        };
      };
    };
  };
}
