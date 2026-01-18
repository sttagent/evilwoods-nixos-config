{
  inputs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkForce;
  inherit (config.evilwoods.base) mainUser;
  secretsPath = builtins.toString inputs.evilsecrets;
  netbird-name = "evilwoods";

in
{
  sops.secrets = {
    netbird-key = {
      sopsFile = secretsPath + "/secrets/aitvaras/default.yaml";
      owner = config.services.netbird.clients.${netbird-name}.user.name;
      group = config.services.netbird.clients.${netbird-name}.user.group;
      mode = "0400";
    };
  };
  services.tailscale.enable = mkForce false;

  users.users.${mainUser} = {
    extraGroups = [ config.services.netbird.clients.${netbird-name}.user.group ];
  };

  services.netbird.clients.${netbird-name} = {
    port = 51820;
    login = {
      enable = true;
      systemdDependencies = [ "sops-install-secrets.service" ];
      setupKeyFile = config.sops.secrets.netbird-key.path;
    };
  };
}
