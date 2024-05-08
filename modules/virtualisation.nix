{ config, lib, ... }:

with lib;
let
  cfg = config.evilwoods;
in
{
  options.evilwoods.podman = mkEnableOption "Podman setup";
  options.evilwoods.docker = mkEnableOption "Docker setup";
  options.evilwoods.libvirtd = mkEnableOption "Libvirtd and virt-manager";

  config = mkMerge [
    (mkIf cfg.podman {
      virtualisation = {
        podman = {
          enable = true;
          enableNvidia = mkIf cfg.nvidia true;
        };
      };
    })

    (mkIf cfg.docker {
      virtualisation = {
        docker = {
          enable = true;
          rootless = {
            enable = true;
            setSocketVariable = true;
          };

          storageDriver = "btrfs";
        };
      };
    })

    (mkIf cfg.libvirtd {
      virtualisation.libvirtd.enable = true;
      programs.virt-manager.enable = true;
    })
  ];
}
