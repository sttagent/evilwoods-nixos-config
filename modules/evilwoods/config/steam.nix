{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  desktop = config.evilwoods.config.desktop;
  cfg = config.evilwoods.config.steam;
in
{
  options.evilwoods.steam.enable = mkEnableOption "Steam";

  config = mkIf (desktop && cfg.enable) {
    programs.steam.enable = true;

    nixpkgs.config.packageOverrides = pkgs: {
      steam = pkgs.steam.override { extraPkgs = pkgs: with pkgs; [ gamescope ]; };
    };
  };
}
