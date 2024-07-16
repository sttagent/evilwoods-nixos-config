{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Desktop apps
    prismlauncher
    nushell
    ffmpeg-full
    cryptomator
    appimage-run
    distrobox
    firefox
    yubioath-flutter
    wl-clipboard
    element-desktop
    standardnotes
    discord
    spotify
    signal-desktop
    zoom-us
    github-desktop
    vscode-fhs
    google-chrome
    zed-editor
    protonmail-desktop
    proton-pass
    bitwarden-cli
    libreoffice-fresh

    # apps specific to Gnome
    gnome-tweaks
    dconf-editor
    notify-client
    bottles
    flare-signal
    gnome-extension-manager
    dconf
    gnome.gnome-sound-recorder
    # fragments
    fractal
    pika-backup
    valent
  ];
}
