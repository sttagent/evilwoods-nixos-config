{
  inputs,
  ...
}:
{
  flake.modules.nixos.hostRynepc =
    {
      config,
      lib,
      ...
    }:
    let
      inherit (lib)
        mkIf
        mkMerge
        mkForce
        ;
      secretsPath = builtins.toString inputs.evilsecrets;
      testEnvEnabled = config.evilwoods.testEnv.enabled;
      mainUser = config.evilwoods.variables.mainUser;

      tailscaleExtraUpFlags = [
        "--ssh"
        "--operator=${mainUser}"
      ];
    in
    {
      config = (
        mkMerge [
          {
            networking = {
              hostName = "rynepc";
              firewall.trustedInterfaces = [ "tailscale0" ];
            };

            services.tailscale = {
              enable = true;
              useRoutingFeatures = "client";
              extraUpFlags = tailscaleExtraUpFlags;
            };
          }

          (mkIf (!testEnvEnabled) {
            sops.secrets.ryne-tailscale-auth-key = {
              sopsFile = secretsPath + "/secrets/ryne/default.yaml";
            };
            services.tailscale.authKeyFile = mkForce config.sops.secrets.ryne-tailscale-auth-key.path;
          })

          (mkIf testEnvEnabled {
            sops.secrets.ryne-tailscale-ephemeral-auth-key = {
              sopsFile = secretsPath + "/secrets/ryne/default.yaml";
            };
            services.tailscale = {
              authKeyFile = mkForce config.sops.secrets.ryne-tailscale-ephemeral-auth-key.path;
            };
          })
        ]
      );
    };
}
