{
  self,
  config,
  lib,
  ...
}:
let
  inherit (lib) types mkOption;
  inherit (builtins) concatStringsSep;

  roles = [
    "server"
    "desktop"
  ];

  desktopEnvironments = [
    "gnome"
    "hyprland"
    "cosmic"
  ];
in
{
  options = {
    evilwoods = {
      constants = {
        desktopEnvironments = mkOption {
          type = types.listOf (types.enum desktopEnvironments);
          default = [
            "gnome"
            "hyprland"
            "cosmic"
          ];
          readOnly = true;
          description = ''
            Available configured desktop environments.
            One of: ${concatStringsSep ", " desktopEnvironments}.
          '';
        };
      };
      base = {
        role = mkOption {
          type = types.nullOr (types.enum roles);
          default = null;
          description = ''
            Role of the host.
            One of: ${concatStringsSep ", " roles}.
          '';
        };
      };
      base = {
        mainUser = mkOption {
          type = types.str;
          default = "aitvaras";
          description = "The primary user of evilwoods.";
        };

        isTestEnv = mkOption {
          type = types.bool;
          default = false;
          description = "Enable or disable testing environment";
        };

        configPath = mkOption {
          type = types.path;
          default = self.outPath + "/hosts/config";
          description = "Path to the configuration directory";
        };

        tailscaleIP = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Tailscale IP address";
        };

        domain = mkOption {
          type = types.str;
          default = "evilwoods.net";
          description = "Domain name";
        };

        shell = mkOption {
          type = types.str;
          default = "fish";
          description = "Default shell";
        };

      };
      config = {

      };
    };
  };

  config = {
    assertions = [
      {
        assertion = config.evilwoods.base.role != null;
        message = "evilwoods.base.role must be set to one of: ${concatStringsSep ", " roles}";
      }

      {
        assertion =
          config.evilwoods.desktop.desktopEnvironment != null -> config.evilwoods.base.role == "desktop";
        message = "evilwoods.base.role must be set to 'desktop' when desktopEnvironments is not empty";
      }
    ];
  };
}
