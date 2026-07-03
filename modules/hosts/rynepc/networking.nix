{
  inputs,
  ...
}:
{
  den.aspects.rynepc.nixos =
    {
      host,
      config,
      lib,
      ...
    }:
    let
      inherit (lib)
        mkForce
        ;
      secretsPath = toString inputs.evilsecrets;
      mainUser = host.mainUser;

      tailscaleExtraUpFlags = [
        "--ssh"
        "--operator=${mainUser}"
      ];
    in
    {
      networking = {
        hostName = host.name;
        firewall.trustedInterfaces = [ "tailscale0" ];
      };

      services.tailscale = {
        enable = true;
        useRoutingFeatures = "client";
        extraUpFlags = tailscaleExtraUpFlags;
      };

      sops.secrets.ryne-tailscale-auth-key = {
        sopsFile = secretsPath + "/secrets/users/ryne.yaml";
      };
      services.tailscale.authKeyFile = mkForce config.sops.secrets.ryne-tailscale-auth-key.path;
    };
}
