{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  desktop = config.evilwoods.desktop;
  steam = config.evilwoods.steam;
in
{
  options.evilwoods.steam = mkEnableOption "Steam";

  config = mkIf (desktop && steam) {
    programs.steam.enable = true;

    nixpkgs.config.packageOverrides = pkgs: {
      steam = pkgs.steam.override { extraPkgs = pkgs: with pkgs; [ gamescope ]; };
    };

    #environment.systemPackages = [ pkgs.gamescope ];

    # Needed for controllers
    # hardware.steam-hardware.enable = true;
  };
}
