{ lib, den, ... }:
{
  # enable hm by default
  den.schema.user = {
    includes = [ den.provides.define-user ];
    classes = lib.mkDefault [ "homeManager" ];
  };
}
