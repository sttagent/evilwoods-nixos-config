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

    services.xserver = {
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };

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
