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
        fzf
        wget
        git
        git-crypt
        htop
        gnupg
        bottom
        gh
        just
      ];
    }
    (mkIf cfg.desktop {
      environment.systemPackages = with pkgs; [
        nushell
        ffmpeg-full
        cryptomator
        appimage-run
        distrobox
        firefox
        yubioath-flutter
        nil
        nixd
        wl-clipboard
        keymapp

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
        pika-backup
        # valent

        # Electron apps
        element-desktop
        standardnotes
        discord
        spotify
        signal-desktop
        zoom-us
        github-desktop

        vscode-fhs
        
        android-studio
      ];
    })
  ];
}
