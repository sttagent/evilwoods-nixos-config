{lib, pkgs, config, ...}:
let
  mainUser = config.evilcfg.mainUses;
in
{
  home-manager.users.${mainUser}.wayland.windowManager.hyprland = {
    enable = true;
  };
}
