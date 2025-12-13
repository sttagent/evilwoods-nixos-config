{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.evilwoods.vmGuest;
in
{
  options.evilwoods.vmGuest.enabled = mkEnableOption "vm guest environment";
  config = mkIf cfg.enabled {
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
