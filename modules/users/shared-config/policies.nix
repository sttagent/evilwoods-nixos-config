{ inputs, den, ... }: {
  den.policies.user-config-on-host =
    { host, user, ... }:
    den.lib.policy.include {
      nixos =
        { config, ... }:
        let
          secretsPath = toString inputs.evilsecrets;
        in
        {
          sops.secrets."${user.name}-password" = {
            sopsFile = "${secretsPath}/secrets/users/${user.name}.yaml";
            neededForUsers = true;
          };
          users.users.${user.name} = {
            uid = user.uid or 1000;
            hashedPasswordFile = config.sops.secrets."${user.name}-password".path;
          };
        };
    };
}
