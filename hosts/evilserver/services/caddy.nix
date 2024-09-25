{
  services.caddy = {
    enable = true;
    globalConfig = ''
      servers {
        trusted_proxies static 100.64.0.0/10 192.168.1.0/24 127.0.0.1/8
      }
    '';
    virtualHosts = {
      "*.evilwoods.net".extraConfig = ''
        tls /var/lib/acme/evilwoods.net/cert.pem /var/lib/acme/evilwoods.net/key.pem

        @kitchenowl host kitchenowl.evilwoods.net
        handle @kitchenowl {
          # forward_auth 127.0.0.1:9091 {
          #   uri /api/authz/forward-auth
          #   copy_headers Remote-User Remote-Groups Remote-Email Remote-Name
          # }
          reverse_proxy http://127.0.0.1:8080
        }

        @auth host auth.evilwoods.net
        handle @auth {
          reverse_proxy 127.0.0.1:9091
        }

        @lt host lt.evilwoods.net
        handle @lt {
          reverse_proxy 127.0.0.1:8010
        }

        @dns host dns.evilwoods.net
        handle @dns {
          # forward_auth 127.0.0.1:9091 {
          #  uri /api/authz/forward-auth
          #  copy_headers Remote-User Remote-Groups Remote-Email Remote-Name
          #}
          reverse_proxy 192.168.1.3:3000
        }

        handle {
          abort
        }
      '';
    };
  };

  users.users.caddy.extraGroups = [ "acme" ];
}
