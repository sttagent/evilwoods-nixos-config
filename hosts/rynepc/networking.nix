{
  inputs,
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
in
{
  config = (
    mkMerge [
      (mkIf (!testEnvEnabled) {
        sops.secrets.ryne-tailscale-auth-key = {
          sopsFile = secretsPath + "/secrets/ryne/ryne.yaml";
        };
        services.tailscale.authKeyFile = mkForce config.sops.secrets.ryne-tailscale-auth-key.path;
      })

      (mkIf testEnvEnabled {
        sops.secrets.ryne-tailscale-ephemeral-auth-key = {
          sopsFile = secretsPath + "/secrets/ryne/ryne.yaml";
        };
        services.tailscale = {
          authKeyFile = mkForce config.sops.secrets.ryne-tailscale-ephemeral-auth-key.path;
        };
      })
    ]
  );
}
