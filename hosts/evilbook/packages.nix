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

    ffmpeg-full
    appimage-run
    distrobox
    # firefox # inastalled by home-manager
    yubioath-flutter
    wl-clipboard
    discord
    zed-editor
    # bitwarden-cli
    gh
    obsidian
    ghostty
    bws
    # google-chrome

    vivaldi-ffmpeg-codecs
    spotify
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
