{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.evilwoods.config.gnome;
in
{
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gnome-keyring
      dconf-editor
      papers
      showtime
      # gnome-extension-manager
      dconf
      valent
      pika-backup
      endeavour
    ];

    environment.gnome.excludePackages = with pkgs; [
      epiphany
      geary
      evince
      totem
      gnome-software
      gnome-tour
    ];

    programs.evolution.enable = true;

  };
}
