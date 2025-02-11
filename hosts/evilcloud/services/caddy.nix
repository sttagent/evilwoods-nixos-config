{
  services.caddy = {
    enable = true;
    globalConfig = ''
      servers {
        trusted_proxies static 100.64.0.0/10 192.168.1.0/24 127.0.0.1/8
      }
    '';
  };
}
