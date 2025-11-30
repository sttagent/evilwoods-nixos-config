# Evilbook configuration

{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [

    # prismlauncher pull three java versions by default.
    # With this override I pull just the one I need fo GTNH.
    (prismlauncher.override {
      jdks = [
        pkgs.jdk25
      ];
    })

    # Vivaldi does not follow gnomes dark mode setting.
    # This config helps with websites and dark mode, but
    # Vivaldi is still not working with dark mode.
    # (vivaldi.override {
    #   commandLineArgs = "--force-dark-mode";
    # })
    # vivaldi-ffmpeg-codecs

    ffmpeg-full
    appimage-run
    distrobox
    yubioath-flutter
    wl-clipboard
    discord
    zed-editor
    gh
    obsidian
    ghostty

    # spotify
    claude-code

    # apps specific to Gnome
    notify-client
    fragments
    fractal
  ];
  programs = {
    firefox = {

    };
  };
}
