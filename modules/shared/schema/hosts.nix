{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  den.schema.host.imports = [
    ({ config, ... }: {
      options = {
        stateVersion = mkOption {
          type = types.str;
        };
        mainUser = mkOption {
          type = types.str;
        };
      };
    })
  ];
}
