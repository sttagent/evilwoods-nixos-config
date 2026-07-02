{
  inputs,
  den,
  lib,
  ...
}:
{
  den.aspects.admin = {
    includes = [
      den.aspects.admin.policies.on-rynepc
      den.aspects.admin.policies.on-evilcloud
    ];
    policies.on-rynepc =
      { host, user, ... }:
      lib.optional (host.name == "rynepc") (den.lib.policy.include den.aspects.admin.rynepc);
    policies.on-evilcloud =
      { host, user, ... }:
      lib.optional (host.name == "evilcloud") (den.lib.policy.include den.aspects.admin.evilcloud);
  };
}
