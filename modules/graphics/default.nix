{config, lib, pkgs, ...}:

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

    environment.systemPackages = with pkgs; [
      nvidia-vaapi-driver
    ];

    hardware = {
      nvidia = mkIf (nvidia && desktop) {
        modesetting.enable = true;
        powerManagement.enable = true;
      };
      opengl = mkIf desktop {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
        extraPackages = with pkgs; [
          vaapiVdpau
        ];          
      };
    };  
  };
}
