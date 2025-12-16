{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (builtins) elem;
  inherit (config.evilwoods.flags) desktopEnvironments;
in
{
  config = mkIf (elem "cosmic" desktopEnvironments) {

    services = {
      displayManager.cosmic-greeter.enable = true;
      desktopManager.cosmic.enable = true;
    };
  };
}
