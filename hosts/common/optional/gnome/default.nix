{ pkgs, ... }:
{
  imports = [ ./packages.nix ];

  environment.systemPackages = with pkgs; [
    gnomeExtensions.appindicator
    gnomeExtensions.valent
    gnomeExtensions.battery-health-charging
    gnomeExtensions.blur-my-shell
  ];

  services.xserver.desktopManager.gnome.enable = true;

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
}
