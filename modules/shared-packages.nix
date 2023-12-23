{ config, pkgs, lib, ... }:
let
  cfg = config.evilcfg;
in
with lib; {
  config = mkMerge [
    {
      environment.systemPackages = with pkgs; [
        zoxide
        neovim
        lazygit
        zellij
        atuin
        ripgrep
        fd
        bat
        eza
        starship
        zoxide
        fzf
        wget
        git
        git-crypt
        htop
        gnupg
        bottom
      ];
    }
    (mkIf cfg.desktop {
      environment.systemPackages = with pkgs; [
        alacritty
        alacritty-theme
        nushell
        ffmpeg-full
        protonvpn-gui
        cryptomator
        appimage-run
        distrobox
        firefox
        yubioath-flutter
        nil
        nixd
        wl-clipboard

        # Gnome apps
        newsflash
        gnome-extension-manager
        blackbox-terminal
        gnome.gnome-tweaks
        gnome.dconf-editor
        dconf
        gnome.gnome-sound-recorder
        fragments
        fractal
        resources
        valent

        # Electron apps
        element-desktop
        discord
        spotify
        signal-desktop
        # obsidian # depends on EOP electron dependency
        zoom-us
        vivaldi

        vscode-fhs

        # thunderbird-wayland
        # protonmail-bridge
      ];
    })
  ];
}
