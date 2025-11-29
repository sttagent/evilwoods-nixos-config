currentUser: { evilib, pkgs, ... }:
let
  inherit (builtins) readFile;
  inherit (evilib) readInVarFile;
in
{
  home-manager.users.${currentUser} = {
    wayland.windowManager.hyprland = {
      enable = true;
      extraConfig = ''
        ${readFile ../../dotfiles/hypr/hyprland.conf}
      '';
    };

    gtk.enable = true;
    xsession.enable = true;

    home.pointerCursor = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
      size = 24;
      gtk.enable = true;
      x11.enable = true;
    };

    programs = {
      wofi = {
        enable = true;
        style = ''
          window {
          margin: 0px;
          border: 1px solid #928374;
          background-color: #282828;
          }

          #input {
          margin: 5px;
          border: none;
          color: #ebdbb2;
          background-color: #1d2021;
          }

          #inner-box {
          margin: 5px;
          border: none;
          background-color: #282828;
          }

          #outer-box {
          margin: 5px;
          border: none;
          background-color: #282828;
          }

          #scroll {
          margin: 0px;
          border: none;
          }

          #text {
          margin: 5px;
          border: none;
          color: #ebdbb2;
          }

          #entry:selected {
          background-color: #1d2021;
          }
        '';
      };
      waybar = {
        enable = true;
        settings = {
          mainBar = {
            layer = "top";
            position = "top";
            height = 24;
            spacing = 4;
            margin-top = 0;
            output = [
              "eDP-1"
              "HDMI-A-1"
            ];
            modules-left = [
              "hyprland/workspaces"
              "hyprland/submap"
            ];
            modules-center = [
              "clock"
            ];
            modules-right = [
              "tray"
              "memory"
              "hyprland/language"
              "wireplumber"
              "network"
              "battery"
              "custom/power"
            ];

            "hyprland/window" = {
              separate-outputs = true;
            };

            "custom/power" = {
              format = "{icon}";
              format-icons = " ";
              menu = "on-click";
              menu-actions = {
                "Suspend" = "systemctl suspend";
                "Reboot" = "systemctl reboot";
                "Shutdown" = "systemctl poweroff";

              };
            };
            battery = {
              states = {
                # good = 95,
                warning = 30;
                critical = 15;
              };
              format = "{capacity}% {icon}";
              format-charging = "{capacity}% ";
              format-plugged = "{capacity}% ";
              format-alt = "{time} {icon}";
              format-icons = [
                " "
                " "
                " "
                " "
                " "
              ];
            };

            memory = {
              format = "{}%  ";
            };

            network = {
              format-wifi = "{essid} ({signalStrength}%)  ";
            };

            wireplumber = {
              format = "{volume}%  ";
            };
          };
        };
        style = ../../dotfiles/waybar/gruv-box.css;
      };
    };

    services.hyprpaper = {
      enable = false;
      settings = {
        ipc = "on";
        splash = false;
        splash_offset = 2.0;

        preload = [ "${../../resources/wallpapers/background1.jpg}" ];

        wallpaper = [
          "HDMI-A-1,${../../resources/wallpapers/background1.jpg}"
          "eDP-1,${../../resources/wallpapers/background1.jpg}"
        ];
      };
    };
  };
}
