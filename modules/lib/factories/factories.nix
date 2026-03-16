{ lib, ... }:
{
  options.flake.lib.factory = lib.mkOption {
    type = lib.types.attrsOf lib.types.unspecified;
    default = { };
  };

}
