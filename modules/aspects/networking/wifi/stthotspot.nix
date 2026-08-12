{ inputs, ... }: {
  den.aspects.networking.wifi.stthotspot.nixos = { config, ... }: {
    sops.secrets = {
      "network-manager-stthotspot.env" = {
        sopsFile = inputs.evilsecrets + "/secrets/users/aitvaras.yaml";
        owner = "root";
        group = "root";
        mode = "0400";
      };
    };
    networking.networkManager.ensureProfiles = {
      environmentFiles = [
        config.sops.secrets."network-manager-stthotspot.env".path
      ];
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
}
