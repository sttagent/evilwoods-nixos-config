{
  inputs,
  ...
}:
{
  flake.modules.nixos.hostNecronomicon =
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
      secretsPath = toString inputs.evilsecrets;
      testEnvEnabled = config.evilwoods.testEnv.enabled;
      mainUser = config.evilwoods.variables.mainUser;
      sopsFile = secretsPath + "/secrets/ryne/default.yaml";

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
              hostName = "necronomicon";
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
              inherit sopsFile;
            };
            services.tailscale.authKeyFile = mkForce config.sops.secrets.ryne-tailscale-auth-key.path;
          })

          (mkIf testEnvEnabled {
            sops.secrets.ryne-tailscale-ephemeral-auth-key = {
              inherit sopsFile;
            };
            services.tailscale = {
              authKeyFile = mkForce config.sops.secrets.ryne-tailscale-ephemeral-auth-key.path;
            };
          })
        ]
      );
    };
}
