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
    zoom-us
    zed-editor
    # bitwarden-cli
    libreoffice-fresh
    gh
    nextcloud-client
    obsidian
    semeru-jre-bin-17
    ghostty
    bws

    # apps specific to Gnome
    newsflash
    notify-client
    tuba
    fragments
    fractal
  ];
}
