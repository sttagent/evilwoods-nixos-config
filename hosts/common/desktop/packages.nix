{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  isDesktop = config.evilwoods.vars.role == "desktop";
in
{
  config = mkIf isDesktop {
    programs.firefox.enable = true;
  };
}
