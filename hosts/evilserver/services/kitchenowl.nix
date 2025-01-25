{
  inputs,
  config,

  lib,
  ...
}:
let
  inherit (lib) genAttrs;
  prefix = config.virtualisation.oci-containers.backend;
  appName = "kitchenowl-app";
  volumeName = "kitchenowl-data";
  serviceName = "${prefix}-${appName}";

  sopsFile = builtins.toString (inputs.evilsecrets + "/secrets/kitchenowl.yaml");
  genKitchenowlSecrets =
    secretList:
    genAttrs secretList (sercert: {
      mode = "0400";
      inherit sopsFile;
    });
in
{
  sops.secrets = genKitchenowlSecrets [
    "kitchenowl-secrets.env"
  ];
  virtualisation.oci-containers.containers = {
    ${appName} = {
      autoStart = true;
      image = "docker.io/tombursch/kitchenowl:v0.6.9";
      # ports = [ "8082:8080" ];
      environmentFiles = [
        config.sops.secrets."kitchenowl-secrets.env".path
      ];
      environment = {
        FRONT_URL = "https://kitchenowl.evilwoods.net";
        OIDC_ISSUER = "https://auth.evilwoods.net";
        DISABLE_USERNAME_PASSWORD_LOGIN = "true";
      };
      volumes = [ "${volumeName}:/data" ];
      extraOptions = [ "--network=host" ];
    };
  };

  # evilwoods.rsyncBackup.backups = {
  #   ${appName} = {
  #     unitFileName = "${podmanServiceName}.service";
  #     srcPath = "/var/storage/docker/volumes/${appVolume}";
  #     snapshotPath = "/var/snapshots/${appName}/docker/volumes/${appVolume}";
  #     dstPath = "/var/backups/docker/volumes/${appVolume}";
  #   };
  # };
}
