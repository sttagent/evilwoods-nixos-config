
{config, pkgs, lib, ...}:

with lib;

let
  desktop = config.evilcfg.desktop;
in {
  config = mkIf desktop {
    environment.systemPackages = with pkgs; [
      nushell
      ffmpeg-full
      gnome.gnome-tweaks
      protonvpn-gui
      realvnc-vnc-viewer
      cryptomator
      appimage-run
      distrobox
      bottles
      firefox
      element-desktop
      discord
      spotify
      standardnotes
      yubioath-flutter
      blackbox-terminal

      (vscode-with-extensions.override {
        vscodeExtensions = with vscode-extensions; [
	  eamodio.gitlens
      vscodevim.vim
      bbenoist.nix
	] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
	  {
	    name = "remote-containers";
	    publisher = "ms-vscode-remote";
	    version = "0.275.1";
	    sha256 = "sha256-A8X5NRfeUrV6ZSi1ZkQ4I6l3hi9pZtvxXm31o/posmE=";
	  }
	];
      })

      # thunderbird-wayland
      # protonmail-bridge
      zoom-us
      gnome-feeds
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
