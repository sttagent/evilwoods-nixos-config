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
      {
        networking = {
          nftables.enable = true;
          useDHCP = true;
        };

        services.firewalld.enable = true;
      }

      (mkIf (!testEnvEnabled) {
        sops.secrets.tailscale-cloud-test-auth-key = {
          sopsFile = secretsPath + "/secrets/common/default.yaml";
        };
        services.tailscale = {
          authKeyFile = mkForce config.sops.secrets.tailscale-cloud-test-auth-key.path;
          extraUpFlags = [
            "--advertise-tags"
            "tag:cloud"
          ];
        };
      })

      (mkIf testEnvEnabled {
        sops.secrets.tailscale-ephemeral-cloud-test-auth-key = {
          sopsFile = secretsPath + "/secrets/common/default.yaml";
        };
        services.tailscale = {
          extraUpFlags = [ "--advertise-tags 'tag:test,tag:cloud'" ];
          authKeyFile = mkForce config.sops.secrets.tailscale-ephemeral-cloud-test-auth-key.path;
        };
      })
    ]
  );
}
