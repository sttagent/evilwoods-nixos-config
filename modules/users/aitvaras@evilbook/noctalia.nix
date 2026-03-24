{ inputs, ... }:
{
  flake.modules.nixos."userAitvaras@evilbook" =
    {
      lib,
      config,
      ...
    }:
    let
      inherit (lib) mkIf;
      inherit (config.evilwoods.variables) desktopEnvironment;
      currentUser = "aitvaras";
      resourceDir = inputs.self.outPath + "/resources";
      wallpaperPath = resourceDir + "/wallpapers/background.jpg";
      noctaliaConfigPath = inputs.self.outPath + "/dotfiles/noctalia";
    in
    {
      config = mkIf (desktopEnvironment == "niri") {
        home-manager.users.${currentUser} = {
          # import the home manager module
          imports = [
            inputs.noctalia.homeModules.default
          ];
          # xdg.autostart.entries = [ ];
          xdg = {
            cacheFile."noctalia/wallpapers.json" = {
              text = builtins.toJSON {
                defaultWallpaper = wallpaperPath;
                wallpapers = {
                  "HDMI-A-1" = wallpaperPath;
                  "eDP-1" = wallpaperPath;
                };
              };
            };

            configFile = {
              "noctalia/" = {
                source = noctaliaConfigPath;
                recursive = true;
              };
            };
          };
        };
      };
    };
}
