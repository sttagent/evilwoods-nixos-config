{ config, pkgs, lib, ... }:
let
  cfg = config.evilwoods;
in
with lib; {
  options.evilwoods.enableGnome = mkEnableOption "Gnome desktop environment";

  config = mkIf cfg.enableGnome {
    evilwoods.desktop = true;

    environment.gnome.excludePackages = with pkgs; [
      epiphany
    ];

    environment.systemPackages = with pkgs; [
      gnomeExtensions.appindicator
      gnomeExtensions.valent
      gnomeExtensions.battery-health-charging
      gnomeExtensions.blur-my-shell

    ];


    services.xserver.desktopManager.gnome.enable = true;

  };
}
