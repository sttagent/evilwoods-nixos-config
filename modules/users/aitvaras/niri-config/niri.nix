{ inputs, ... }:
{
  den.aspects.aitvaras.niri = {
    homeManager =
      {
        lib,
        pkgs,
        ...
      }:
      let
        noctalia-exec = lib.getExe inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
        niri-config = inputs.self.outPath + "/dotfiles/niri/config.kdl";
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
                      criteria = "eDP-1";
                      mode = "1920x1080@60.042";
                      transform = "normal";
                    }
                    {
                      criteria = "*C32JG5x*";
                      mode = "2560x1440@99.946";
                      adaptiveSync = true;
                      position = "2560,-420";
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
          "niri/config.kdl" = {
            text = ''
              include  "${niri-config}"
              spawn-at-startup "${noctalia-exec}"
              binds {
                "Super+Alt+N" hotkey-overlay-title=null {
                  spawn-sh  "pkill noctalia || exec ${noctalia-exec}";
                }
              }
              include optional=true "overrides.kdl"
            '';
          };
        };
      };
  };
}
