{ config, ... }:
let
  mainUser = config.evilwoods.mainUser;
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
}
