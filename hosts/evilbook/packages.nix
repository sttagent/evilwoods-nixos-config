# Evilbook configuration

{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Desktop apps
    prismlauncher
    nushell
    ffmpeg-full
    appimage-run
    distrobox
    firefox
    yubioath-flutter
    wl-clipboard
    standardnotes
    discord
    signal-desktop
    zoom-us
    zed-editor
    protonmail-desktop
    proton-pass
    bitwarden-cli
    libreoffice-fresh
    vivaldi
    vivaldi-ffmpeg-codecs
    warp-terminal

    # apps specific to Gnome
    gnome-tweaks
    dconf-editor
    notify-client
    flare-signal
    gnome-extension-manager
    dconf
    gnome.gnome-sound-recorder
    # fragments
    fractal
    pika-backup
    valent
    fragments
  ];
}
