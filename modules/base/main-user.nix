{ config, pkgs, lib, ... }:

with lib;

let
  mainUser = config.evilwoods.mainUser;
in
{
  options.evilwoods.mainUser = mkOption {
    type = types.str;
    default = "aitvaras";
    description = "The primary user of evilwoods.";
  };
}
