{lib, pkgs, config, ...}:
let
  mainUser = config.evilcfg.mainUser;
  hyprConfigDir = "../../configfiles/hypr";
in
with builtins; {
  home-manager.users.${mainUser}.wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = [
        "DP-3, 2560x1440@144, 0x0, 1"
        "HDMI-A-1 ,1920x10080@60, 2560x360, 1"
      ];

    };
    extraConfig = ''
      ${readFile ./${hyprConfigDir}/hyprland.conf}
    '';
  };
}
