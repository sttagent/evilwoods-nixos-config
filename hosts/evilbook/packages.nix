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
    signal-desktop
    zoom-us
    zed-editor
    bitwarden-cli
    libreoffice-fresh
    gh
    nextcloud-client
    obsidian
    # bitwarden-desktop # doesnt build
    semeru-jre-bin-17
    code-cursor

    # apps specific to Gnome
    notify-client
    flare-signal
    gnome-sound-recorder
    tuba
    fragments
    fractal
    fragments
  ];
}
