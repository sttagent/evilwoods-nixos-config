{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  den.schema.user.imports = [
    ({ config, ... }: {
      options = {
        uid = mkOption {
          type = types.nullOr types.int;
          default = null;
        };
        description = mkOption {
          type = types.nullOr types.str;
          default = null;
        };
      };
    })
  ];
}
