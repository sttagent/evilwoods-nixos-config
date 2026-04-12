{
  flake.modules.nixos.base =
    { lib, ... }:
    let
      inherit (lib) types mkOption;
    in

    {
      options = {
        evilwoods = {
          flags = {
            isDesktop = mkOption {
              description = "The host is a desktop.";
              type = types.bool;
              default = false;
            };
            vmGuest = mkOption {
              description = "The host is a VM guest.";
              type = types.bool;
              default = false;
            };
          };

          variables = {
            mainUser = mkOption {
              type = types.str;
              default = "aitvaras";
              description = "The primary user of evilwoods.";
            };
          };

          constants = {
            evilwoodsDomain = mkOption {
              type = types.str;
              default = "evilwoods.net";
              description = "Domain name";
              readOnly = true;
            };
          };
        };
      };

      config = {
        # assertions = [
        #   {
        #     assertion = config.evilwoods.variables.role != null;
        #     message = "evilwoods.base.role must be set to one of: ${concatStringsSep ", " roles}";
        #   }

        #   {
        #     assertion =
        #       config.evilwoods.desktop.desktopEnvironment != null -> config.evilwoods.variables.role == "desktop";
        #     message = "evilwoods.base.role must be set to 'desktop' when desktopEnvironments is not empty";
        #   }
        # ];
      };
    };
}
