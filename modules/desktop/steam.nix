{config, pkgs, lib, ...	}:

with lib;

let
  desktop = config.evilcfg.desktop;
  steam = config.evilcfg.steam;
in {
  options.evilcfg.steam = mkEnableOption "Steam";

  config = mkIf (desktop && steam) {
    programs.steam.enable = true;

    # Needed for controllers
    # hardware.steam-hardware.enable = true;
  };
}
