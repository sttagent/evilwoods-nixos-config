{
  services.caddy = {
    enable = true;
    virtualHosts = {
      "*.evilwoods.net".extraConfig = ''
        tls /var/lib/acme/evilwoods.net/cert.pem /var/lib/acme/evilwoods.net/key.pem

        @kitchenowl host kitchenowl.evilwoods.net
        handle @kitchenowl {
          reverse_proxy http://127.0.0.1:8081
        }

        handle {
          abort
        }
      '';
    };
  };

  users.users.caddy.extraGroups = [ "acme" ];
}
