  services.caddy = {
    enable = true;
    virtualHosts = {
      ":443".extraConfig = ''
        tls /var/lib/acme/evilwoods.net/cert.pem /var/lib/acme/evilwoods.net/key.pem
      '';
    };
  };

  users.users.caddy.extraGroups = [ "acme" ];
}
