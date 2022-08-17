{config, lib, ...}:

with lib;

let
  nvidia = config.evilcfg.nvidia;
in {
  opions.evilcfg.nvidia = mkEnableOtpion "nvidea";

  config = mkIf nvidia {
   services.xserver.videoDrivers = [ "nvidia" ];
   hardware.nvidia.modesetting = true;
   hardware.nvidia.powerManagement.enable   = true;
  };
}
