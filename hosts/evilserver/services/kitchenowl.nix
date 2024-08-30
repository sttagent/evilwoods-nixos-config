{ inputs, config, pkgs, lib, ... }:
let
  inherit (lib) genAttrs;
  appName = "kitchenowl-app";
  appVolume = "kitchenowl_data";
  dockeServiceName = "docker-${appName}";
  rsyncServiceName = "rsync-${appName}";
  snapshotServiceName = "snapshot-${appName}";
  srcPath = "/var/snapshots/${appName}/docker/volumes/${appVolume}";
  dstPath = "/var/backups/docker/volumes/${appVolume}";
  
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
    "kitchenowl-secret.env"
  ];
  virtualisation.oci-containers.containers = {
    ${appName} = {
      autoStart = true;
      image = "docker.io/tombursch/kitchenowl:v0.5.2";
      # ports = [ "8081:8080" ];
      environmentFiles = [
        config.sops.secrets."kitchenowl-secret.env".path
      ];
      environment = {
        FRONT_URL = "https://kitchenowl.evilwoods.net";
        OIDC_ISSUER = "https://auth.evilwoods.net";
        JWT_SECRET_KEY = "satan_spawn";
      };
      volumes = [ "${appVolume}:/data" ];
      extraOptions = [ "--network=host" ];
    };
  };

  evilwoods.rsyncBackup.backups = {
    ${appName} = {
      unitFileName = "${dockeServiceName}.service";
      srcPath = "/var/storage/docker/volumes/${appVolume}";
      snapshotPath = "/var/snapshots/${appName}/docker/volumes/${appVolume}";
      dstPath = "/var/backups/docker/volumes/${appVolume}";
    };
  };
}
