{ inputs, configPath, ... }:
let
  common_mount_options = [
    "noatime"
    "defaults"
    "compress=zstd"
  ];
in
{
  imports = [
    inputs.disko-2405.nixosModules.disko

    (configPath + "/hardware/partition_schemes/evilserver-only-sandisk.nix")
  ];

  fileSystems = {
    "/var/storage/external-hdd/backups" = {
      device = "/dev/disk/by-label/external-hdd";
      fsType = "btrfs";
      options = [
        "subvol=backups"
      ] ++ common_mount_options;
    };
    "/var/storage/external-hdd/snapshots" = {
      device = "/dev/disk/by-label/external-hdd";
      fsType = "btrfs";
      options = [
        "subvol=snapshots"
      ] ++ common_mount_options;
    };
    "/var/lib/containers" = {
      device = "/dev/disk/by-label/internal-ssd";
      fsType = "btrfs";
      options = [
        "subvol=containers/system"
      ] ++ common_mount_options;
    };
    "/var/storage/internal-ssd/storage" = {
      device = "/dev/disk/by-label/internal-ssd";
      fsType = "btrfs";
      options = [
        "subvol=storage"
      ] ++ common_mount_options;
    };
    "/var/storage/internal-ssd/snapshots" = {
      device = "/dev/disk/by-label/internal-ssd";
      fsType = "btrfs";
      options = [
        "subvol=snapshots"
      ] ++ common_mount_options;
    };
  };
}
