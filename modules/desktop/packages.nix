{ config, pkgs, lib, ... }:

with lib;

let
  desktop = config.evilcfg.desktop;
in
{
  config = mkIf desktop {
    fonts.packages = with pkgs; [
      (nerdfonts.override { fonts = [ "SourceCodePro" ]; })
    ];
    environment.systemPackages = with pkgs; [
      alacritty
      alacritty-theme
      nushell
      ffmpeg-full
      protonvpn-gui
      cryptomator
      appimage-run
      distrobox
      firefox
      yubioath-flutter
      nil
      nixd
      wl-clipboard

      # Gnome apps
      newsflash
      gnome-extension-manager
      blackbox-terminal
      gnome.gnome-tweaks
      gnome.dconf-editor
      dconf
      gnome.gnome-sound-recorder
      fragments
      fractal
      resources
      valent

      # Electron apps
      element-desktop
      discord
      spotify
      signal-desktop
      obsidian
      zoom-us
      vivaldi

      vscode-fhs

      # thunderbird-wayland
      # protonmail-bridge
    ];

    environment.variables = {
      MOZ_ENABLE_WAYLAND = "1";
      EDITOR = "nvim";
      NIXOS_OZONE_WL = "1";
    };

    environment.gnome.excludePackages = with pkgs; [
      epiphany
    ];
  };
}
