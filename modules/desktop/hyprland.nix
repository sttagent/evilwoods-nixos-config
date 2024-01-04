{lib, pkgs, config, ...}:
with lib;
let
  cfg = config.evilcfg;
in
{
  options.evilcfg = {
    enableHyprland = mkEnableOption "Hyprland window manager";
  };

  config = mkIf cfg.enableHyprland {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal
        # xdg-desktop-portal-gtk
      ];
    };

    environment =  {
      systemPackages = with pkgs; [
        waybar
        wofi
        ];

      sessionVariables = {
        WLR_NO_HARDWARE_CURSORS = "1";
      };
    };
  };
}
