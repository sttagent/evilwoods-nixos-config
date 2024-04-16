{inputs, config, pkgs, ... }:
let
  cfg = config.evilcfg;
in 
{
  config.environment.systemPackages = with pkgs; [
    bottom
    zoxide
    neovim
    lazygit
    zellij
    atuin
    ripgrep
    fd
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
    just
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
  ] ++ lib.optionals cfg.enableGnome [
    newsflash
    gnome-extension-manager
    blackbox-terminal
    gnome.gnome-tweaks
    gnome.dconf-editor
    dconf
    gnome.gnome-sound-recorder
    fragments
    fractal
    pika-backup
    # valent # doesn't build
  ];
}
