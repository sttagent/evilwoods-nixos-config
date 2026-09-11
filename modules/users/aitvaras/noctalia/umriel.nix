{ inputs, ... }:
{
  den.aspects.aitvaras.noctalia = {
    homeManager =
      {
        lib,
        pkgs,
        ...
      }:
      let
        noctalia-exec = lib.getExe pkgs.noctalia;
        umbriel-exec = lib.getExe pkgs.umbriel;
        umbriel-config = inputs.self.outPath + "/dotfiles/umbriel/config.toml";
        umbriel-keybinds = inputs.self.outPath + "/dotfiles/umbriel/keybinds.toml";
      in
      {
        dconf.settings = {
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
            gtk-theme = "Adwaita-dark";
            accent-color = "green";
          };
        };

        services = {
          kanshi = {
            enable = true;
            settings = [
              {
                profile = {
                  name = "laptop-only";
                  outputs = [
                    {
                      criteria = "eDP-1";
                      mode = "1920x1080@60.042";
                      scale = 1.25;
                      transform = "normal";
                      position = "0,0";
                    }
                  ];
                  exec = [
                    "${noctalia-exec} msg bar-show default eDP-1"
                  ];
                };
              }
              {
                profile = {
                  name = "external-monitor";
                  outputs = [
                    {
                      criteria = "*C32JG5x*";
                      mode = "2560x1440@99.946";
                      adaptiveSync = true;
                      position = "0,0";
                    }
                    {
                      criteria = "eDP-1";
                      mode = "1920x1080@60.042";
                      transform = "normal";
                      position = "2560,440";
                    }
                  ];
                  exec = [
                    "${noctalia-exec} msg bar-hide default eDP-1"
                  ];
                };
              }
            ];
          };
        };

        xdg.configFile = {
          "umbriel/config.toml" = {
            text = ''
              [include]
                files = [
                  "${umbriel-config}",
                  "${umbriel-keybinds}"
                ]
              [include.optional]
                files = [
                  "~/.config/umbriel/noctalia.toml",
                  "~/.config/umbriel/overrides.toml"
                ]
            '';
          };
        };
      };
  };
}
