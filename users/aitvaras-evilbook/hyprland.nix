{ evilib, ... }:
let
  inherit (builtins) readFile;
  inherit (evilib) readInVarFile;
  inherit (readInVarFile ../aitvaras/vars.toml) thisUser;
in
{
  home-manager.users.${thisUser} = {
    wayland.windowManager.hyprland = {
      enable = true;
      extraConfig = ''
        ${readFile ../../configfiles/hypr/hyprland.conf}
      '';
    };
  };
}
