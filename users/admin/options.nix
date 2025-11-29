currentUser:
{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.evilwoods.${currentUser}.shell = mkOption {
    type = types.str;
    default = "fish";
  };
}
