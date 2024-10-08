{ inputs, config, ... }:
{
  sops.secrets.searx-secret = {
    sopsFile = builtins.toString (inputs.evilsecrets + "/secrets/searx.yaml");
    mode = "0600";
    owner = "searx";
    group = "searx";
  };

  services.searx = {
    enable = true;
    environmentFile = config.sops.secrets.searx-secret.path;
    settings = {
      server = {
        port = 8082;
        bind_address = "127.0.0.1";
      };
    };
  };

  services.caddy.virtualHosts."search.evilwoods.net" = {
    useACMEHost = "evilwoods.net";
    extraConfig = ''
      reverse_proxy 127.0.0.1:8082
    '';
  };
}
