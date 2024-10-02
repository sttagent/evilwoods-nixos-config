# Evilbook configuration

{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [

    prismlauncher
    nushell
    ffmpeg-full
    appimage-run
    distrobox
    firefox
    yubioath-flutter
    wl-clipboard
    discord
    signal-desktop
    zoom-us
    zed-editor
    bitwarden-cli
    libreoffice-fresh
    warp-terminal
    gh
    thunderbird
    megasync
    megacmd
    nextcloud-client
    vivaldi
    vivaldi-ffmpeg-codecs
    widevine-cdm

    # apps specific to Gnome
    gnome-tweaks
    dconf-editor
    notify-client
    flare-signal
    gnome-extension-manager
    dconf
    gnome-sound-recorder
    tuba
    fragments
    fractal
    pika-backup
    valent
    fragments
    papers
    showtime
  ];
}
