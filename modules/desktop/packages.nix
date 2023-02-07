
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
      megasync
      megacmd
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

      vivaldi
      vivaldi-widevine
      vivaldi-ffmpeg-codecs

      /*
      (vscode-with-extensions.override {
        vscodeExtensions = with vscode-extensions; [
	  eamodio.gitlens
	] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
	  {
	    name = "remote-containers";
	    publisher = "ms-vscode-remote";
	    version = "0.251.0";
	    sha256 = "sha256-quAgBzBd3lCsN+5KbqOqECJxw675ix9ciR9+R6us9WE=";
	  }
	  
	  {
	    name = "mips";
	    publisher = "kdarkhan";
	    version = "0.1.0";
	    sha256 = "sha256-1fhkl7aEuW1pE42nvxfG+UT0uS7e7Hwnqqk/qP0oKAI=";
	  }
	];
      })
      */

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
