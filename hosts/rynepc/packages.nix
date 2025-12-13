{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    ffmpeg-full
    appimage-run
    yubioath-flutter
    wl-clipboard
    discord
    obsidian
    ghostty
    # spotify

    # apps specific to Gnome
    notify-client
    fragments
    fractal
    filen-desktop
  ];
}
