{ config, lib, ... }:
let
  isNotTestEnv = !config.evilwoods.isTestEnv;
in
{
  services.caddy = {
    enable = false;
    virtualHosts = lib.mkIf isNotTestEnv {
      ":443".extraConfig = ''
        tls /var/lib/acme/evilwoods.net/cert.pem /var/lib/acme/evilwoods.net/key.pem
      '';
      "ntfy.evilwoods.net".extraConfig = ''
        reverse_proxy http://127.0.0.1:8080
      '';
      "evilclouddns.evilwoods.net".extraConfig = ''
        reverse_proxy http://127.0.0.1:3000
      '';
    };
  };

  # users.users.caddy.extraGroups = [ "acme" ];
}
