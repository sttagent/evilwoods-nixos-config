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
  gnome = config.evilwoods.config.gnome;
in
{
  options = {
    evilwoods.config.hyprland.enable = mkEnableOption "Enable Hyprland";
  };

  config = mkMerge [
    (mkIf cfg.enable {
      programs = {
        hyprland.enable = true;
        waybar.enable = true;

      };

      environment.systemPackages = with pkgs; [
        wofi
      ];
    })

    (mkIf (cfg.enable && !gnome.enable) { })
  ];
}
