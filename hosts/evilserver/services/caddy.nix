{
  services.caddy = {
    enable = true;
    virtualHosts = {
      "kitchenowl.evilwoods.net".extraConfig = ''
        tls /var/lib/acme/evilwoods.net/cert.pem /var/lib/acme/evilwoods.net/key.pem
        reverse_proxy http://127.0.0.1:8081
      '';
    };
  };

  users.users.caddy.extraGroups = [ "acme" ];
}
