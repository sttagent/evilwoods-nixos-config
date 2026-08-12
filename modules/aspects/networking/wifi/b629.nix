{ inputs, ... }: {
  den.aspects.networking.wifi.b629.nixos = { config, ... }: {
    sops.secrets = {
      "network-manager-b629.env" = {
        sopsFile = inputs.evilsecrets + "/secrets/users/aitvaras.yaml";
        owner = "root";
        group = "root";
        mode = "0400";
      };
    };
    networking.networkManager.ensureProfiles = {
      environmentFiles = [
        config.sops.secrets."network-manager-b629.env".path
      ];
      profiles = {
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
      };
    };
  };
}
