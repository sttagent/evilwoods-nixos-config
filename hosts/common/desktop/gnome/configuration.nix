{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (config.evilwoods.desktop) desktopEnvironment;
in
{

  config = mkIf (desktopEnvironment == "gnome") {

    services = {
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
