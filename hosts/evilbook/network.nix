{ inputs, config, ... }:
let
  secretsPath = builtins.toString inputs.evilsecrets;
in
{

  sops.secrets = {
    "network-manager.env" = { };
    "network-manager-b629.env" = {
      sopsFile = secretsPath + "/secrets/aitvaras/default.yaml";
      owner = "root";
      group = "root";
      mode = "0400";
    };
    "network-manager-stthotspot.env" = {
      sopsFile = secretsPath + "/secrets/aitvaras/default.yaml";
      owner = "root";
      group = "root";
      mode = "0400";
    };
  };
  services.firewalld.enable = true;

  services.resolved = {
    enable = true;
    dnssec = "true";
    dnsovertls = "true";
    domains = [ "~." ];
    fallbackDns = [
    ];
    extraConfig = ''
      DNS=76.76.2.22#27aq5r8yhzg.dns.controld.com
    '';
  };

  networking = {
    nftables.enable = true;

    wireless.iwd.enable = true;

    nameservers = [
      "127.0.0.1"
      "::1"
    ];

    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
      ensureProfiles = {
        environmentFiles = [
          config.sops.secrets."network-manager.env".path
          config.sops.secrets."network-manager-b629.env".path
          config.sops.secrets."network-manager-stthotspot.env".path
        ];
        profiles = {
          evilwoods-5G = {
            connection = {
              id = "evilwoods-5G";
              type = "wifi";
              interface-name = "wlan0";
              autoconnect = true;
            };
            wifi = {
              mode = "infrastructure";
              ssid = "evilwoods-5G";
            };
            wifi-security = {
              auth-alg = "open";
              key-mgmt = "wpa-psk";
              psk = "$evilwoods_psk";
            };
            ipv4 = {
              method = "auto";
            };
            ipv6 = {
              addr-gen-mode = "default";
              method = "auto";
            };
            proxy = { };
          };
          b629-5G = {
            connection = {
              id = "629-5GHz";
              type = "wifi";
              interface-name = "wlan0";
              autoconnect = true;
            };
            wifi = {
              mode = "infrastructure";
              ssid = "629-5GHz";
            };
            wifi-security = {
              auth-alg = "open";
              key-mgmt = "wpa-psk";
              psk = "$b629_psk";
            };
            ipv4 = {
              method = "auto";
            };
            ipv6 = {
              addr-gen-mode = "default";
              method = "auto";
            };
            proxy = { };
          };
          stthotspot = {
            connection = {
              id = "stthotspot";
              type = "wifi";
              interface-name = "wlan0";
              autoconnect = true;
            };
            wifi = {
              mode = "infrastructure";
              ssid = "stthotspot";
            };
            wifi-security = {
              auth-alg = "open";
              key-mgmt = "wpa-psk";
              psk = "$stthotspot_psk";
            };
            ipv4 = {
              method = "auto";
            };
            ipv6 = {
              addr-gen-mode = "default";
              method = "auto";
            };
            proxy = { };
          };
        };
      };
    };
  };
}
