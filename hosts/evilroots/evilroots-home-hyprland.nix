{lib, pkgs, config, ...}:
let
  mainUser = config.evilcfg.mainUser;
  hyprConfigDir = "../../configfiles/hypr";
in
{
  home-manager.users.${mainUser}.wayland.windowManager.hyprland = {
    enable = true;
  };
}
