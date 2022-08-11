{config, pkgs, lib, ...	}:

with lib;

let
  cfg = config.sys;
  desktop = config.sys.desktop.enable;
  steam = config.sys.desktop.steam.enable;
in {
  options.sys.desktop.steam.enable = mkEnableOption "Steam";

  config = mkIf (desktop && steam) {
    programs.steam.enable = true;

    # Needed for controllers
    # hardware.steam-hardware.enable = true;

  };
}
