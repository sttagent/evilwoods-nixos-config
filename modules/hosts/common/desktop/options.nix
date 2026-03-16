{
  flake.modules.nixos.desktop =
    { lib, ... }:
    let
      inherit (lib) types mkOption;
      inherit (builtins) concatStringsSep;

      desktopEnvironments = [
        "gnome"
        "hyprland"
        "cosmic"
        "niri"
      ];
    in
    {
      options.evilwoods = {
        variables = {
          desktopEnvironment = mkOption {
            type = types.nullOr (types.enum desktopEnvironments);
            default = null;
            description = ''
              The desktop environment of the host.
              One of: ${concatStringsSep ", " desktopEnvironments}.
            '';
          };

          constants.availableDesktopEnvironments = mkOption {
            type = types.listOf types.str;
            default = desktopEnvironments;
            readOnly = true;
            description = ''
              Available configured desktop environments.
              One of: ${concatStringsSep ", " desktopEnvironments}.
            '';
          };
        };
      };
    };
}
