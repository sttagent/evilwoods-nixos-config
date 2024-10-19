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
    thunderbird
    nextcloud-client
    obsidian
    # bitwarden-desktop # doesnt build
    vscode-fhs

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
