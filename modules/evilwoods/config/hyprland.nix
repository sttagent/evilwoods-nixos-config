{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkOption
    mkMerge
    mkIf
    mkEnableOption
    ;
  cfg = config.evilwoods.config.hyprland;
  gnome = true;
in
{
  options = {
    evilwoods.config.hyprland.enable = mkEnableOption "Enable Hyprland";
  };

  config = mkMerge [
    (mkIf cfg.enable {
      programs = {
        hyprland.enable = true;
        hyprlock.enable = true;
        waybar.enable = true;
      };

      services = {
        hypridle.enable = true;

      };


      environment.systemPackages = with pkgs; [
        wofi
      ];
    })

    (mkIf (cfg.enable && !gnome) {
      services.xserver.displayManager.gdm.enable = true;
    })
  ];
}
