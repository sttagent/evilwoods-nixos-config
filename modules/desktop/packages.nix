
{config, pkgs, lib, ...}:

with lib;

let
  desktop = config.evilcfg.desktop;
in {
  config = mkIf desktop {
    environment.systemPackages = with pkgs; [
      firefox-wayland
      nushell
      ffmpeg-full
      gnome-feeds
      yubioath-desktop
      gnomeExtensions.appindicator
      element-desktop
      discord
      spotify
      standardnotes
      gnome.gnome-tweaks
      thunderbird-wayland
      protonvpn-gui
      realvnc-vnc-viewer
      cryptomator
      protonmail-bridge
      appimage-run
      zoom-us
    ];

    environment.variables = {
      MOZ_ENABLE_WAYLAND = "1";
      EDITOR = "nvim";
    };

    environment.gnome.excludePackages = with pkgs; [
      epiphany
    ];
  };
}
