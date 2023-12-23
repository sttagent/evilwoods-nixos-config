{ config, pkgs, lib, ... }:

with lib;

let
  desktop = config.evilcfg.desktop;
in
{
  config = mkIf desktop {
    fonts.packages = with pkgs; [
      (nerdfonts.override { fonts = [ "SourceCodePro" ]; })
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
