{ inputs, ... }:
{
  flake.modules.nixos.serviceSearx =
    { config, ... }:
    let
      appPort = "8082";
      appName = "searx";
      appURL = "search.evilwoods.net";
    in
    {
      sops.secrets.searx-secret = {
        sopsFile = toString (inputs.evilsecrets + "/secrets/evilcloud/searx.yaml");
        mode = "0600";
        owner = "searx";
        group = "searx";
      };

      services = {
        searx = {
          enable = true;
          environmentFile = config.sops.secrets.searx-secret.path;
          redisCreateLocally = true;
          settings = {
            general = {
              instance_name = "Evilwoods Search";
            };
            server = {
              port = appPort;
              bind_address = "127.0.0.1";
              base_url = "https://${appURL}";
            };
            search = {
              autocomplete = "duckduckgo";
            };
            ui = {
              hotkeys = "vim";
              infinate_scroll = true;
            };
          };
        };
        traefik.dynamicConfigOptions.http = {
          routers.${appName} = {
            rule = "Host(`${appURL}`)";
            service = "${appName}";
            entryPoints = "websecure";
            tls.certResolver = "letsencrypt";
          };
          services.${appName}.loadBalancer.servers = [
            { url = "http://127.0.0.1:${appPort}"; }
          ];
        };
      };
    };
}
