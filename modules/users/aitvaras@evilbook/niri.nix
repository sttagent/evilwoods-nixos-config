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
      inherit (lib) mkIf getExe;
      inherit (config.evilwoods.variables) desktopEnvironment;
      hmlib = inputs.home-manager.lib;
      noctalia-shell-exec = getExe pkgs.noctalia-shell;
      currentUser = "aitvaras";
      niriDefaultConfigPath = inputs.self.outPath + "/dotfiles/niri/config.kdl";
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

          xdg.configFile = {
            "niri/config.kdl" = {
              text = hmlib.hm.generators.toKDL { } {
                # The elements of _children list appear before attributes in generated
                # config file and in the order they are added to the list. _Children
                # can also contain duplicates.
                # Root level _children. Appears at the top of the file.
                _children = [
                  {
                    include = {
                      # Optional includes are not available in 25.11. According to the
                      # dcoumentation, this will be available in the next version.
                      # _props.optional = true;
                      _args = [ (toString niriDefaultConfigPath) ];
                    };
                  }
                ];
                spawn-at-startup = [
                  noctalia-shell-exec
                ];
              };
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
                      "${noctalia-shell-exec} ipc call bar setDisplayMode always_visible eDP-1"
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
                      "${noctalia-shell-exec} ipc call bar setDisplayMode auto_hide eDP-1"
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
