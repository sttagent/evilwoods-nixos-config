{ lib, den, ... }:
{
  # enable hm by default
  den.schema.user = {
    includes = [
      den.provides.define-user
      den.batteries.host-aspects
    ];
    classes = lib.mkDefault [
      "homeManager"
    ];
  };
}
