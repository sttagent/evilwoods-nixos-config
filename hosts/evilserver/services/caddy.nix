{
  services.caddy = {
    enable = true;
    virtualHosts = {
      "kitchenowl.evilwoods.net".extraConfig = ''
        reverse_proxy http://127.0.0.1:8081
      '';
    };
  };
}
