{
  services = {
    blocky = {
      enable = true;
      settings = {
        upstreams = {
          groups.default = [ "1.1.1.1" ];
        };
        ports = {
          dns = "100.100.53.98:53";
        };
        customDNS = {
          mapping."domain.test" = "100.100.53.98";
        };
      };
    };
  };
}
