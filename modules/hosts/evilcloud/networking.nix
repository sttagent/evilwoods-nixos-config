{
  inputs,
  ...
}:
{
  flake.modules.nixos.hostEvilcloud =
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
              hostName = "evilcloud";
              useDHCP = true;
              firewall.trustedInterfaces = [ "tailscale0" ];
            };

            services = {
              tailscale = {
                enable = true;
                useRoutingFeatures = "client";
                extraUpFlags = tailscaleExtraUpFlags;
              };
            };
          }

          (mkIf (!testEnvEnabled) {
            sops.secrets.tailscale-cloud-auth-key = {
              sopsFile = secretsPath + "/secrets/common/default.yaml";
            };
            services.tailscale = {
              authKeyFile = mkForce config.sops.secrets.tailscale-cloud-auth-key.path;
              extraUpFlags = tailscaleExtraUpFlags ++ [
                "--advertise-tags=tag:remote-server"
              ];
            };
          })

          (mkIf testEnvEnabled {
            sops.secrets.tailscale-ephemeral-cloud-test-auth-key = {
              sopsFile = secretsPath + "/secrets/common/default.yaml";
            };
            services.tailscale = {
              extraUpFlags = tailscaleExtraUpFlags ++ [ "--advertise-tags=tag:test,tag:remote-server" ];
              authKeyFile = mkForce config.sops.secrets.tailscale-ephemeral-cloud-test-auth-key.path;
            };
          })
        ]
      );
    };
}
