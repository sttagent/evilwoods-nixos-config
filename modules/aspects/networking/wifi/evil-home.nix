{
  den.aspects.networking.wifi.evilHome = {
    nixos = { config, ... }: {
      sops.secrets = {
        "network-manager.env" = { };
      };
      networking = {
        networkManager = {
          ensureProfiles = {
            environmentFiles = [
              config.sops.secrets."network-manager.env".path
            ];
            profiles = {
              evilwoods-5G = {
                connection = {
                  id = "evil-home-5g";
                  type = "wifi";
                  interface-name = "wlan0";
                  autoconnect = true;
                };
                wifi = {
                  mode = "infrastructure";
                  ssid = "evil-home-5g";
                };
                wifi-security = {
                  auth-alg = "open";
                  key-mgmt = "wpa-psk";
                  psk = "$evilhome_psk";
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
    };
  };
}
