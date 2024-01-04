{lib, pkgs, config, ...}:
let
  mainUser = config.evilcfg.mainUser;
  hyprConfigDir = "../../configfiles/hypr";
in
with builtins; {
  home-manager.users.${mainUser}.wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = ''
      ${readFile ./${hyprConfigDir}/hyprland.conf}
    '';
  };
}
