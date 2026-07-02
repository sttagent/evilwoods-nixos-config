{ den, ... }: {
  den.schema.user = {
    includes = [
      den.policies.user-config-on-host
    ];
  };
}
