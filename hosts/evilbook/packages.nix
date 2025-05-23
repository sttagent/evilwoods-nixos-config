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
    gh
    obsidian
    semeru-jre-bin-17
    ghostty
    bws
    filen-cli
    filen-desktop
    google-chrome

    # apps specific to Gnome
    notify-client
    fragments
    fractal
  ];
}
