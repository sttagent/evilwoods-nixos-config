{ inputs, ... }: {
  den.aspects.networking.wifi.degerman.nixos = { config, ... }: {
    sops.secrets."network-manager-degerman.env" = { };

    networking.networkManager.ensureProfiles = {
      environmentFiles = [
        config.sops.secrets."network-manager-degerman.env".path
      ];
      profiles = {
        Degerman = {
          connection = {
            id = "Degerman";
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
