{config, lib, ...}:

with lib;

let
  nvidia = config.evilcfg.nvidia;
  desktop = config.evilcfg.desktop;
in {
  options.evilcfg.nvidia = mkEnableOption "nvidia";

  config = mkIf nvidia {
    services.xserver = mkIf nvidia {
      videoDrivers = [ "nvidia" ];
    };

    hardware = {
      nvidia = mkIf (nvidia && desktop) {
        modesetting.enable = true;
        powerManagement.enable = true;
      };
      opengl = mkIf desktop {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
      };
    };  
  };
}
