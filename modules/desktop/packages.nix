
{config, pkgs, pkgsUnstable, lib, ...}:

with lib;

let
  desktop = config.sys.desktop.enable;
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

      # Packages from ustable repository
      thunderbird-wayland
      protonvpn-gui
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
