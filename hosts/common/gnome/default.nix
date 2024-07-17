{ pkgs, ... }:
{
  imports = [
    ./packages.nix
  ];


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

  programs.dconf.enable = true;

  services.udisks2.settings = {
    "udisks2.conf" = {
      defaults = {
        encryption = "luks2";
        btrfs_defaults = "compress=zstd";
      };
      udisks2 = {
        modules = [
          "*"
        ];
        modules_load_preference = "ondemand";
      };
    };
  };
}
