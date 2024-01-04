{ config, pkgs, lib, ...}:
let
  cfg = config.evilcfg;
in
with lib; {
  options.evilcfg.enableGnome = mkEnableOption "Gnome desktop environment";

  config = mkIf cfg.desktop {
    evilcfg.desktop = true;

    environment.gnome.excludePackages = with pkgs; [
      epiphany
    ];

    environment.systemPackages = with pkgs; [
      gnomeExtensions.appindicator
      gnomeExtensions.blur-my-shell
      gnomeExtensions.valent
    ];


    services.xserver.desktopManager.gnome.enable = true;

  };
}
