{ inputs, config, ... }:
{
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    validateSopsFiles = false;
    age = {
      keyFile = "/home/aitvaras/.config/sops/age/keys.txt";
    };

    secrets = {
      "network-manager.env" = { };
    };
  };
}
