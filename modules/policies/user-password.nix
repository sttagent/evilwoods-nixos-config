{ den, ... }: {
  den.policies.user-password =
    { host, user, ... }:
    den.lib.policy.include {
      nixos =
        { config, ... }:
        let
          user-password = "${user.name}-password";
        in
        {
          sops.secrets."${user-password}" = {
            sopsFile = user.secretPath;
            neededForUsers = true;
          };
          users.users.${user.name} = {
            description = user.description;
            uid = user.uid or 1000;
            hashedPasswordFile = config.sops.secrets."${user-password}".path;
          };
        };
    };
}
