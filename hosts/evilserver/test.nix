# The file is not imported by default

{ config, lib, ... }:
{
  imports = [ ./default.nix ];

  sops.secrets.tailscale-ephemeral-auth-key = { };
  services.tailscale.authKeyFile = lib.mkForce config.config.sops.tailscale-ephemeral-auth-key.path;
  
  virtualisation.vmVariant.virtualisation.sharedDirectories = {
    ssh-key = {
        source = "/ect/ssh";
        destination = "/ect/ssh";
    };
  };
}
