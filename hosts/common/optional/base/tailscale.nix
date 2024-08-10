{ config, lib, ... }:
let
  inherit (lib) mkIf;

  mainUser = config.evilwoods.mainUser;
  isTestEnv = config.evilwoods.isTestEnv;
in
{
  # tailscale configuration
  sops.secrets.tailscale-auth-key = { };
  networking.firewall.trustedInterfaces = [ "tailscale0" ];
  services = {
    tailscale = {
      enable = true;
      useRoutingFeatures = "client";
      extraUpFlags = [
        "--ssh"
        "--operator=${mainUser}"
      ];
      authKeyFile = config.sops.secrets.tailscale-auth-key.path;
    };
  };
} // (mkIf isTestEnv {
  sops.secrets.tailscale-ephemeral-auth-key = { };
  services.tailscale.authKeyFile = lib.mkForce config.sops.secrets.tailscale-ephemeral-auth-key.path;
})
