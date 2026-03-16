{ inputs, ... }:
{
  flake.modules.nixos.serviceNiks3 =
    { config, ... }:
    let
      secretsPath = toString inputs.evilsecrets;

      appName = "cache";
      appPort = "5751";
      appURL = "${appName}.${config.evilwoods.constants.domain}";
    in
    {
      imports = [
        inputs.niks3.nixosModules.default
      ];

      sops.secrets = {
        niks3-api-token = {
          sopsFile = secretsPath + "/secrets/evilcloud/cloudflare-r2.yaml";
          owner = "niks3";
          group = "niks3";
          mode = "0400";
        };
        niks3-s3-access-key = {
          sopsFile = secretsPath + "/secrets/evilcloud/cloudflare-r2.yaml";
          owner = "niks3";
          group = "niks3";
          mode = "0400";
        };
        niks3-s3-secret-key = {
          sopsFile = secretsPath + "/secrets/evilcloud/cloudflare-r2.yaml";
          owner = "niks3";
          group = "niks3";
          mode = "0400";
        };
        evilwoods-nix-key = {
          sopsFile = secretsPath + "/secrets/nix-key.yaml";
          owner = "niks3";
          group = "niks3";
          mode = "0400";
        };
      };

      services = {
        niks3 = {
          enable = true;
          apiTokenFile = config.sops.secrets."niks3-api-token".path;
          signKeyFiles = [ config.sops.secrets."evilwoods-nix-key".path ];
          readProxy.enable = true;
          httpAddr = "127.0.0.1:${appPort}";
          s3 = {
            endpoint = "2d63b3be832263c9eff3ad7054f75e1b.r2.cloudflarestorage.com"; # or your S3-compatible endpoint
            bucket = "evilwoods-nix-cache";
            region = "auto";
            useSSL = true;
            accessKeyFile = config.sops.secrets."niks3-s3-access-key".path;
            secretKeyFile = config.sops.secrets."niks3-s3-secret-key".path;
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
            { url = "http://localhost:${appPort}"; }
          ];
        };
      };
    };
}
