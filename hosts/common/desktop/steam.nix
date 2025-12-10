{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  isDesktop = config.evilwoods.flags.role == "desktop";
  cfg = config.evilwoods.steam;
in
{
  options.evilwoods.steam.enabled = mkEnableOption "Steam";

  config = mkIf (isDesktop && cfg.enabled) {
    programs.steam = {
      enable = true;
      extraPackages = with pkgs; [
        gamescope
      ];
    };
    hardware.steam-hardware.enable = true;

  };
}
