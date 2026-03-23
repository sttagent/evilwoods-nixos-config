{ inputs, ... }:
{
  flake.modules.nixos."userAitvaras@evilbook" =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib) mkIf;
      inherit (config.evilwoods.variables) desktopEnvironment;
      inherit (pkgs.stdenv.hostPlatform) system;
      noctalia-pkg = inputs.noctalia.packages.${system}.default;
      noctalia-shell-bin = "${noctalia-pkg}/bin/noctalia-shell";
      currentUser = "aitvaras";
      niriConfigPath = inputs.self.outPath + "/dotfiles/niri/config.kdl";
    in
    {

      config = mkIf (desktopEnvironment == "niri") {
        home-manager.users.${currentUser} = {
          dconf.settings = {
            "org/gnome/desktop/interface" = {
              color-scheme = "prefer-dark";
              gtk-theme = "Adwaita-dark";
              accent-color = "green";
            };
          };

          xdg.configFile."niri/config.kdl" = {
            source = niriConfigPath;
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
                      "${noctalia-shell-bin} ipc call bar setDisplayMode always_visible eDP-1"
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
                      "${noctalia-shell-bin} ipc call bar setDisplayMode auto_hide eDP-1"
                    ];
                  };
                }
              ];
            };
          };
        };
      };
    };
}
