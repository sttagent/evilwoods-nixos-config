{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.evilwoods.config.gnome;
in
{
  options.evilwoods.config.gnome.enable = mkEnableOption "gnome config";

  config = mkIf cfg.enable {
    evilwoods.config.desktop.enable = true;

    environment.systemPackages = with pkgs; [
      gnomeExtensions.appindicator
      gnomeExtensions.valent
      gnomeExtensions.battery-health-charging
      gnomeExtensions.blur-my-shell
    ];

    services.xserver = {
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };

    programs.dconf.enable = true;

    services.udisks2.settings = {
      "udisks2.conf" = {
        defaults = {
          encryption = "luks2";
          btrfs_defaults = "compress=zstd";
        };
        udisks2 = {
          modules = [ "*" ];
          modules_load_preference = "ondemand";
        };
      };
    };
  };
}
