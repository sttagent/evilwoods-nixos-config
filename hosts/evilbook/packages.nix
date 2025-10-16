# Evilbook configuration

{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [

    prismlauncher
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
    temurin-jre-bin-25
    ghostty
    bws
    google-chrome
    vivaldi
    vivaldi-ffmpeg-codecs
    spotify

    # apps specific to Gnome
    notify-client
    fragments
    fractal
  ];
}
