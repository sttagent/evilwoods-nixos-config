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
    environment.systemPackages = with pkgs; [
      gnome-keyring
      dconf-editor
      papers
      showtime
      gnome-extension-manager
      gsettings-desktop-schemas
      dconf
      valent # does not build on nixos-unstable
      pika-backup
      endeavour

      gnomeExtensions.appindicator
      gnomeExtensions.valent
      gnomeExtensions.battery-health-charging
      gnomeExtensions.blur-my-shell

    ];

    environment.gnome.excludePackages = with pkgs; [
      epiphany
      geary
      evince
      totem
      gnome-software
      gnome-tour
    ];

    programs = {
      dconf.enable = true;
      # evolution.enable = true;
    };

  };
}
