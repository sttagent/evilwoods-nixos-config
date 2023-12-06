{ config, pkgs, lib, ... }:

with lib;

let
  desktop = config.evilcfg.desktop;
in
{
  config = mkIf desktop {
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
      nerdfonts

      # Gnome apps
      newsflash
      gnome-extension-manager
      blackbox-terminal
      gnome.gnome-tweaks
      gnome.dconf-editor
      dconf
      gnome.gnome-sound-recorder
      fragments
      # valent # doesnt compile
      #  fractal # doesn't compile

      # Electron apps
      element-desktop
      discord
      spotify
      signal-desktop
      obsidian
      zoom-us

      (vscode-with-extensions.override {
        vscodeExtensions = with vscode-extensions; [
          eamodio.gitlens
          ms-vscode-remote.remote-containers
          ms-vscode-remote.remote-ssh
          asvetliakov.vscode-neovim
          github.copilot
          github.copilot-chat
          ms-python.python
          ms-python.vscode-pylance
          esbenp.prettier-vscode
          ms-azuretools.vscode-docker
          tailscale.vscode-tailscale
          jnoortheen.nix-ide
          arrterian.nix-env-selector
          jdinhlife.gruvbox
          redhat.vscode-yaml
          ms-vsliveshare.vsliveshare
          mkhl.direnv
          github.vscode-github-actions
        ];
      })

      # thunderbird-wayland
      # protonmail-bridge
    ];

    environment.variables = {
      MOZ_ENABLE_WAYLAND = "1";
      EDITOR = "nvim";
      NIXOS_OZONE_WL = "1";
    };

    environment.gnome.excludePackages = with pkgs; [
      epiphany
    ];
  };
}
