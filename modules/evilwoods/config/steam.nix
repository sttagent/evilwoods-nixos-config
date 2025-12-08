{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  isDesktop = config.evilwoods.flags.role == "desktop";
  cfg = config.evilwoods.config.steam;
in
{
  options.evilwoods.config.steam.enable = mkEnableOption "Steam";

  config = mkIf (isDesktop && cfg.enable) {
    programs.steam = {
      enable = true;
      extraPackages = with pkgs; [
        gamescope
      ];
    };
    hardware.steam-hardware.enable = true;

  };
}
