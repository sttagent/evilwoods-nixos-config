
{config, pkgs, lib, ...}:

with lib;

let
  desktop = config.evilcfg.desktop;
in {
  config = mkIf desktop {
    environment.systemPackages = with pkgs; [
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
      # valent # doesnt compile

      # Gnome apps
      newsflash
      gnome-extension-manager
      blackbox-terminal
      gnome.gnome-tweaks
      #  fractal # doesn't compile

      # Electron apps
      element-desktop
      discord
      spotify
      signal-desktop
      obsidian

      (vscode-with-extensions.override {
        vscodeExtensions = with vscode-extensions; [
	        eamodio.gitlens
          vscodevim.vim
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
	      ];
      })

      # thunderbird-wayland
      # protonmail-bridge
      zoom-us
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
