{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    ffmpeg-full
    appimage-run
    distrobox
    yubioath-flutter
    wl-clipboard
    discord
    obsidian
    ghostty
    # spotify
    claude-code

    # apps specific to Gnome
    notify-client
    fragments
    fractal
    filen-desktop
  ];
}
