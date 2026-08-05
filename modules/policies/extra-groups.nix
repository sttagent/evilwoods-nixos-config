{ den, ... }: {
  den.policies.user-extra-groups =
    { host, user, ... }:
    den.lib.policy.include {
      nixos = {
        users.users.${user.name}.extraGroups = user.extraGroups;
      };
    };
}
