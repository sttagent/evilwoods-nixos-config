{
  den,
  inputs,
  lib,
  ...
}:
{
  den.aspects.aitvaras = {
    includes = [
      den.aspects.aitvaras.policies.on-evilbook
    ];
    policies = {
      on-evilbook =
        { host, user, ... }:
        lib.optional (host.name == "evilbook") (den.lib.policy.include den.aspects.aitvaras.evilbook);
    };
  };
}
