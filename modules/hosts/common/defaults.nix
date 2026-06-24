{ den, ... }: {
  den.schema.host = {
    home-manager.enable = true;
    includes = [
      den.policies.to-users
      den.aspects.hostBase
    ];
  };
}
