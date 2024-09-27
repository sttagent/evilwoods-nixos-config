{
  inputs,
  configPath,
  ...
}:
let
  common_mount_options = [
    "noatime"
    "defaults"
    "compress=zstd"
  ];
in
{
  imports = [
    (configPath + "/common")
    (configPath + "/server")

    inputs.sops-nix-2405.nixosModules.sops
    inputs.home-manager-2405.nixosModules.home-manager

  ];

  nix.settings = {
    trusted-users = [
      "root"
      "@wheel"
    ];
  };

  services.fstrim.enable = true;

  programs.nix-ld = {
    enable = true;
  };

  virtualisation = {
    oci-containers = {
      backend = "podman";
    };
  };

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

  evilwoods = {
    rsyncBackup.defaults = {
      srcSubvol = "/var/storage/internal-ssh/storage";
      snapshotSubvol = "/var/storage/internal-ssh/snapshots";
      dstSubvol = "/var/storage/external-hdd/backups";
      rsyncPrefix = "rsync";
      snapshotPrefix = "snapshot";
    };
  };

  # networking.interfaces.enp3s0.useDHCP = lib.mkDefault true;
}
