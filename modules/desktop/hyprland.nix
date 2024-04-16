{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.evilcfg;
in
{
  options.evilcfg = {
    enableHyprland = mkEnableOption "Hyprland window manager";
  };

  config = mkMerge [
    (mkIf cfg.enableHyprland {
      evilcfg.desktop = true;
      programs.hyprland = {
        enable = true;
        xwayland.enable = true;
      };

      security = {
        polkit.enable = true;
      };

      environment = {
        systemPackages = with pkgs; [
          hyprpaper
        ];
      };
    })

    (mkIf (! cfg.enableGnome) {
      xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal
          xdg-desktop-portal-gtk
          xdg-desktop-portal-gnome
        ];
      };

      environment.systemPackages = with pkgs.gnome; [
        pkgs.cantarell-fonts
        pkgs.loupe
        adwaita-icon-theme
        nautilus
        baobab
        gnome-calendar
        gnome-boxes
        gnome-system-monitor
        gnome-control-center
        gnome-weather
        gnome-calculator
        gnome-clocks
        gnome-software # for flatpak
      ];

      systemd = {
        user.services.polkit-gnome-authentication-agent-1 = {
          description = "polkit-gnome-authentication-agent-1";
          wantedBy = [ "graphical-session.target" ];
          wants = [ "graphical-session.target" ];
          after = [ "graphical-session.target" ];
          serviceConfig = {
            Type = "simple";
            ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
            Restart = "on-failure";
            RestartSec = 1;
            TimeoutStopSec = 10;
          };
        };
      };

      services = {
        gvfs.enable = true;
        devmon.enable = true;
        udisks2.enable = true;
        upower.enable = true;
        power-profiles-daemon.enable = true;
        accounts-daemon.enable = true;
        gnome = {
          sushi.enable = true;
          evolution-data-server.enable = true;
          glib-networking.enable = true;
          gnome-keyring.enable = true;
          gnome-online-accounts.enable = true;
        };
      };
    })
  ];
}
