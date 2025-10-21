# Evilbook configuration

{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [

    (prismlauncher.override {
      jdks = [
        pkgs.jdk25
      ];
    })
    ffmpeg-full
    appimage-run
    distrobox
    # firefox # inastalled by home-manager
    yubioath-flutter
    wl-clipboard
    discord
    zed-editor
    # bitwarden-cli
    gh
    obsidian
    ghostty
    bws
    google-chrome
    vivaldi
    vivaldi-ffmpeg-codecs
    spotify
    claude-code

    # apps specific to Gnome
    notify-client
    fragments
    fractal
  ];
}
