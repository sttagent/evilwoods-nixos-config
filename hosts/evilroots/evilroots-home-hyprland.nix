{lib, pkgs, config, ...}:
let
  mainUser = config.evilcfg.mainUser;
  hyprConfigDir = "../../configfiles/hypr";
in
with builtins; {
  home-manager.users.${mainUser} =  {
    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        env =   [
          "LIBVA_DRIVER_NAME,nvidia"
          "XDG_SESSION_TYPE,wayland"
          "GBM_BACKEND,nvidia-drm"
          "__GLX_VENDOR_LIBRARY_NAME,nvidia"
          "WLR_NO_HARDWARE_CURSORS,1"
        ];

        monitor = [
          "DP-3, 2560x1440@144, 0x0, 1"
          "HDMI-A-1 ,1920x10080@60, 2560x360, 1"
        ];

        workspace = [
          "9,monitor:HDMI-A-1,default:true"
          "1,monitor:DP-3,default:true"
        ];

        exec-once = [
          "hyprctl dispatch workspace 1"
        ];
      };
      extraConfig = ''
        ${readFile ./${hyprConfigDir}/hyprland.conf}
      '';
    };

    services.mako.enable = true;
    programs = {
      waybar = {
        enable = true;
        systemd = {
          enable = true;
          target = "hyprland-session.target";
        };
      };
      wofi.enable = true;
    };
  };
}
