{
  den,
  inputs,
  lib,
  ...
}:
{
  den.policies.aitvaras-to-hosts =
    { user, ... }:
    den.lib.policy.include {
      nixos =
        { config, ... }:
        let
          secretsPath = toString inputs.evilsecrets;
        in
        {
          sops.secrets."${user.name}-password" = {
            sopsFile = "${secretsPath}/secrets/${user.name}/default.yaml";
            neededForUsers = true;
          };
          users.users.${user.name} = {
            hashedPasswordFile = config.sops.secrets."${user.name}-password".path;
          };
        };
    };

  den.policies.aitvaras-on-evilbook =
    { host, user, ... }:
    lib.optional (host.name == "evilbook") (den.lib.policy.include den.aspects.aitvaras.evilbook);

  den.aspects.aitvaras.includes = [
    den.policies.aitvaras-to-hosts
    den.policies.aitvaras-on-evilbook
  ];
}
