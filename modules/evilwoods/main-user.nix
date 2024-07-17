{ lib, ... }:
{
  options.evilwoods.mainUser = lib.mkOption {
    type = lib.types.str;
    default = "aitvaras";
    description = "The primary user of evilwoods.";
  };
}
