{ inputs, config, pkgs, ... }:
let
  cfg = config.evilwoods;
in
{
  config.environment.systemPackages = with pkgs; [
    bottom
    zoxide
    neovim
    zellij
    atuin
    ripgrep
    fd
    sd
    bat
    eza
    fzf
    wget
    git
    git-crypt
    htop
    gnupg
    gh
    dust
    just
    pinentry-curses
  ] ++ lib.optionals cfg.desktop [
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
    onlyoffice-bin_latest
  ] ++ lib.optionals cfg.enableGnome [
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
    valent # doesn't build
  ];
}
