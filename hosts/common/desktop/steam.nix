{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  isDesktop = config.evilwoods.base.role == "desktop";
  cfg = config.evilwoods.steam;
in
{
  options.evilwoods.steam.enabled = mkEnableOption "Steam";

  # write some assersions instead fo this.
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
