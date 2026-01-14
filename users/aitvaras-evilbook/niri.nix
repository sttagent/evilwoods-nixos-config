currentUser:
{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (config.evilwoods.desktop) desktopEnvironment;
in
{
  config = mkIf (desktopEnvironment == "niri") {
    home-manager.users.${currentUser} = {
      # import the home manager module
      imports = [
        inputs.noctalia.homeModules.default
      ];

      # configure options
      programs = {
        noctalia-shell = {

          enable = true;
          settings = {
            # configure noctalia here
            bar = {
              density = "compact";
              position = "right";
              showCapsule = false;
              widgets = {
                left = [
                  {
                    id = "ControlCenter";
                    useDistroLogo = true;
                  }
                  {
                    id = "WiFi";
                  }
                  {
                    id = "Bluetooth";
                  }
                ];
                center = [
                  {
                    hideUnoccupied = false;
                    id = "Workspace";
                    labelMode = "none";
                  }
                ];
                right = [
                  {
                    alwaysShowPercentage = false;
                    id = "Battery";
                    warningThreshold = 30;
                  }
                  {
                    formatHorizontal = "HH:mm";
                    formatVertical = "HH mm";
                    id = "Clock";
                    useMonospacedFont = true;
                    usePrimaryColor = true;
                  }
                ];
              };
            };
            colorSchemes.predefinedScheme = "Monochrome";
            general = {
              # avatarImage = "/home/drfoobar/.face";
              # radiusRatio = 0.2;
            };
            location = {
              monthBeforeDay = true;
              name = "Stockholm, Sweden";
            };
          };
          # this may also be a string or a path to a JSON file.
        };
      };
    };
  };
}
