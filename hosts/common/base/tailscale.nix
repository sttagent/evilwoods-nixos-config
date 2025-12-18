{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    mkMerge
    ;

  mainUser = config.evilwoods.base.mainUser;
  testEnvEnabled = config.evilwoods.testEnv.enabled;

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

      (mkIf (!testEnvEnabled) {
        sops.secrets.tailscale-auth-key = { };
        services.tailscale.authKeyFile = config.sops.secrets.tailscale-auth-key.path;
      })

      (mkIf testEnvEnabled {
        sops.secrets.tailscale-ephemeral-auth-key = { };
        services.tailscale = {
          authKeyFile = config.sops.secrets.tailscale-ephemeral-auth-key.path;
        };
      })
    ]
  );
}
