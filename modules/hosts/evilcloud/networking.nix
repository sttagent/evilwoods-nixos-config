{
  inputs,
  ...
}:
{
  den.aspects.evilcloud.nixos =
    {
      host,
      config,
      lib,
      ...
    }:
    let
      secretsPath = toString inputs.evilsecrets;
    in
    {
      sops.secrets.tailscale-cloud-auth-key = {
        sopsFile = secretsPath + "/secrets/hosts/common/.yaml";
      };
      networking = {
        hostName = host.name;
        useDHCP = true;
      };
      services.tailscale.authKeyFile = lib.mkForce config.sops.secrets.tailscale-cloud-auth-key.path;
    };
}
