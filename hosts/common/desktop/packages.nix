{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (config.evilwoods.vars) mainUser;
  isDesktop = config.evilwoods.vars.role == "desktop";
in
{
  config = mkIf isDesktop {
    programs.firefox.enable = true;
  };
}
