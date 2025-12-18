{
  config,
  lib,
  ...
}:
let
  inherit (lib) types mkOption;
  inherit (builtins) concatStringsSep;
  inherit (config.evilwoods.constants) desktopEnvironments;
in
{
  options.evilwoods.desktop = {
    desktopEnvironment = mkOption {
      type = types.nullOr (types.enum desktopEnvironments);
      default = null;
      description = ''
        The desktop environment of the host.
        One of: ${concatStringsSep ", " desktopEnvironments}.
      '';
    };
  };
}
