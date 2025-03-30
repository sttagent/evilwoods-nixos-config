{ config, lib, ... }:
let
  inherit (lib)
    mkIf
    mkMerge
    ;

  mainUser = config.evilwoods.vars.mainUser;
  isTestEnv = config.evilwoods.vars.isTestEnv;
  tailscaleExtraUpFlags = [
    "--ssh"
    "--operator=${mainUser}"
  ];
in
{

  config = (
    mkMerge [
      {
        # tailscale configuration
        networking.firewall.trustedInterfaces = [ "tailscale0" ];
        services = {
          tailscale = {
            enable = true;
            useRoutingFeatures = "client";
            extraUpFlags = tailscaleExtraUpFlags;
          };
        };
      }

      (mkIf (!isTestEnv) {
        sops.secrets.tailscale-auth-key = { };
        services.tailscale.authKeyFile = config.sops.secrets.tailscale-auth-key.path;
      })

      (mkIf isTestEnv {
        sops.secrets.tailscale-ephemeral-auth-key = { };
        services.tailscale.authKeyFile = config.sops.secrets.tailscale-ephemeral-auth-key.path;
      })
    ]
  );
}
