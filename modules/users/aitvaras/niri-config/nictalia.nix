{ inputs, ... }:
{
  den.aspects.aitvaras.niri.homeManager =
    {
      lib,
      config,
      ...
    }:
    let
      inherit (lib) mkIf;
      resourceDir = inputs.self.outPath + "/resources";
      wallpaperPath = resourceDir + "/wallpapers/background.jpg";
      noctaliaConfigPath = inputs.self.outPath + "/dotfiles/noctalia";
    in
    {
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
}
