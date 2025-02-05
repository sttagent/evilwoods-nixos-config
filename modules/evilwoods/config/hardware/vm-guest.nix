{
  modulesPath,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf optionals;
  cfg = config.evilwoods.config.vmGuest;
in
{
  options.evilwoods.config.vmGuest.enable = mkEnableOption "vm guest config";
  config = mkIf cfg.enable {
    hardware.enableRedistributableFirmware = lib.mkDefault true;
    boot.initrd.availableKernelModules = [
      "virtio_net"
      "virtio_pci"
      "virtio_mmio"
      "virtio_blk"
      "virtio_scsi"
      "9p"
      "9pnet_virtio"
    ];
    boot.initrd.kernelModules = [
      "virtio_balloon"
      "virtio_console"
      "virtio_rng"
      "virtio_gpu"
    ];
    services.qemuGuest.enable = true;
  };
}
