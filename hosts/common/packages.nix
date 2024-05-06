{ inputs, config, pkgs, ... }:
let
  cfg = config.evilcfg;
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
    bottom
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
    android-studio
    google-chrome
    zed-editor
    protonmail-desktop
  ] ++ lib.optionals cfg.enableGnome [
    flare-signal
    gnome-extension-manager
    gnome.gnome-tweaks
    gnome.dconf-editor
    dconf
    gnome.gnome-sound-recorder
    fragments
    fractal
    pika-backup
    valent # doesn't build
  ];
}
