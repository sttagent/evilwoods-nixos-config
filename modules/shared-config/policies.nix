{ den, ... }: {
  den.policies.to-users =
    { host, user, ... }:
    den.lib.policy.include {
      homeManager = {
        home.stateVersion = host.stateVersion;
      };
    };
}
