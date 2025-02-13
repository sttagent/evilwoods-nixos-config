# This file contains configuration for the KitchenOwl service.
# It spins up a container image. Authentication is handled by
# Authelia.

{
  inputs,
  config,
  lib,
  ...
}:
let
  inherit (lib) genAttrs;
  inherit (config.evilwoods.vars) domain;
  inherit (config.evilwoods.host.vars) dataPath;
  prefix = config.virtualisation.oci-containers.backend;
  appName = "kitchenowl";
  legoListenHTTPPort = "1360";
  kitchenOwlurl = "${appName}.${domain}";
  kitchenOwlDataPath = "${dataPath}/${appName}";
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

  systemd.tmpfiles.rules = [
    "d ${kitchenOwlDataPath} 0775 root root"
  ];

  virtualisation.oci-containers.containers = {
    ${appName} = {
      autoStart = true;
      image = "docker.io/tombursch/kitchenowl:v0.6.10";
      # ports = [ "8082:8080" ];
      environmentFiles = [
        config.sops.secrets."kitchenowl-secrets.env".path
      ];
      environment = {
        FRONT_URL = "https://${kitchenOwlurl}";
        OIDC_ISSUER = "https://auth.evilwoods.net";
        DISABLE_USERNAME_PASSWORD_LOGIN = "true";
      };
      volumes = [ "${kitchenOwlDataPath}:/data" ];
      extraOptions = [ "--network=host" ];
    };
  };

  services.caddy.virtualHosts."${kitchenOwlurl}" = {
    useACMEHost = "${kitchenOwlurl}";
    extraConfig = ''
      reverse_proxy http://localhost:8080
    '';
  };

  security.acme.certs."${kitchenOwlurl}" = {
    domain = "${kitchenOwlurl}";
    listenHTTP = ":${legoListenHTTPPort}";
    reloadServices = [ "caddy.service" ];
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
