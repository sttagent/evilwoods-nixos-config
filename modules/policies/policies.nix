{ den, ... }: {
  den.policies.home-manager-state-version =
    { host, user, ... }:
    den.lib.policy.include {
      homeManager = {
        home.stateVersion = host.stateVersion;
      };
    };
}
