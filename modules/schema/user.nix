{
  inputs,
  den,
  lib,
  ...
}:
let
  inherit (lib) mkOption types;
  secrets = inputs.evilsecrets + "/secrets/users";
in
{
  den.schema.user = {
    imports = [
      ({ config, ... }: {
        options = {
          description = mkOption {
            type = types.str;
            default = "";
          };
          uid = mkOption {
            type = types.nullOr types.int;
            default = null;
          };
          secretPath = mkOption {
            type = types.path;
            default = secrets + "/${config.name}.yaml";
          };
          extraGroups = mkOption {
            type = types.listOf types.str;
            default = [ ];
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
      den.policies.user-extra-groups

      (den.lib.policy.mkPolicy "primary-user-for-main" (
        { host, user, ... }:
        lib.optional (user.name == (host.mainUser or null)) (
          den.lib.policy.include den.batteries.primary-user
        )
      ))
    ];
  };
}
