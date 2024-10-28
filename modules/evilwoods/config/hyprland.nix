{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkOption
    mkMerge
    mkIf
    mkEnableOption
    ;
  cfg = config.evilwoods.config.hyprland;
  gnome = config.evilwoods.config.gnome;
in
{
  options = {
    evilwoods.config.hyprland.enable = mkEnableOption "Enable Hyprland";
  };

  config = mkMerge [
    (mkIf cfg.enable {

      boot.plymouth.enable = false;

      programs = {
        hyprland.enable = true;
        hyprlock.enable = true;
        waybar.enable = true;
      };

      services = {
        hypridle.enable = true;

        power-profiles-daemon.enable = true;

        gnome.gnome-keyring.enable = true;
      };

      # security.pam.services.gdm-password.enableGnomeKeyring = true;

      environment.systemPackages = with pkgs; [
        wofi
        hyprpaper
        wl-clipboard
        adwaita-icon-theme
      ];
      environment = {
        variables = {
          XCURSOR_THEME = "adwaita";
          XCURSOR_SIZE = "32";
        };
      };
    })

    (mkIf (cfg.enable && !gnome.enable) {
      evilwoods.config.desktop.enable = true;

      services.greetd = {
        enable = true;
        settings = {
          default_session =
            let
              sessions = "${config.services.displayManager.sessionData.desktops}/share/xsessions:${config.services.displayManager.sessionData.desktops}/share/wayland-sessions";
            in
            {
              command = "${pkgs.greetd.tuigreet}/bin/tuigreet --sessions ${sessions} --time --asterisks --remember --remember-user-session";
              user = "greeter";
            };
        };
      };
    })
  ];
}
