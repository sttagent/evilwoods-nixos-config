{ config, pkgs, lib, ... }:
let
  cfg = config.evilwoods;
in
{
  options.evilwoods.enableGnome = lib.mkEnableOption "Gnome desktop environment";

  config = lib.mkIf cfg.enableGnome {
    evilwoods.desktop = true;

    environment.gnome.excludePackages = with pkgs; [
      epiphany
    ];

    environment.systemPackages = with pkgs; [
      gnomeExtensions.appindicator
      gnomeExtensions.valent
      gnomeExtensions.battery-health-charging
      gnomeExtensions.blur-my-shell
      gnomeExtensions.dash-to-dock
    ];


    services.xserver.desktopManager.gnome.enable = true;

  };
}
