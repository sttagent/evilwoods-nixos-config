# Evilbook configuration

{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [

    prismlauncher
    nushell
    ffmpeg-full
    appimage-run
    distrobox
    # firefox
    yubioath-flutter
    wl-clipboard
    discord
    signal-desktop
    zoom-us
    zed-editor
    bitwarden-cli
    libreoffice-fresh
    # warp-terminal
    gh
    thunderbird
    # megasync
    # megacmd
    nextcloud-client
    obsidian
    logseq
    bitwarden-desktop

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
