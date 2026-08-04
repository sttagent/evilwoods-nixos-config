{ den, lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  den.schema.user = {
    imports = [
      ({ config, ... }: {
        options = {
          uid = mkOption {
            type = types.nullOr types.int;
            default = null;
          };
          description = mkOption {
            type = types.str;
            default = "";
          };
        };
      })
    ];

    classes = lib.mkDefault [
      "homeManager"
    ];

    includes = [
      den.batteries.define-user
      den.batteries.host-aspects
      den.policies.user-password

      (den.lib.policy.mkPolicy "primary-user-for-main" (
        { host, user, ... }:
        lib.optional (user.name == (host.mainUser or null)) (
          den.lib.policy.include den.batteries.primary-user
        )
      ))
    ];
  };
}
