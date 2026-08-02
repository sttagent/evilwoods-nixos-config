{
  den,
  lib,
  ...
}:
{
  den.reservedKeys = [ "settings" ];

  den.schema.user = {
    classes = lib.mkDefault [
      "homeManager"
    ];

    includes = [
      den.batteries.define-user
      den.batteries.host-aspects

      (den.lib.policy.mkPolicy "primary-user-for-main" (
        { host, user, ... }:
        lib.optional (user.name == (host.mainUser or null)) (
          den.lib.policy.include den.batteries.primary-user
        )
      ))
    ];
  };
}
