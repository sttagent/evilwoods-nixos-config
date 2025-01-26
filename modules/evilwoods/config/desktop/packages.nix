{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  mainUser = config.evilwoods.vars.mainUser;
  cfg = config.evilwoods.config.desktop;
in
{
  config = mkIf cfg.enable {
  };
}
