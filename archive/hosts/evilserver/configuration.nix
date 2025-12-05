{
  inputs,
  configPath,
  ...
}:
{
  imports = [
    inputs.sops-nix-2411.nixosModules.sops
    inputs.home-manager-2411.nixosModules.home-manager
  ];

  evilwoods = {
    vars = {
      role = "server";
      tailscaleIP = "100.94.134.11";
    };
    storage = {
      externalHddBackupVolume = "/var/storage/external-hdd/backup";
      externalHddSnapshotVolume = "/var/storage/external-hdd/snapshots";
      internalSsdContainersVolume = "/var/storage/internal-ssd/containers";
      internalSsdStorageVolume = "/var/storage/internal-ssd/storage";
      internalSsdSnapshotVolume = "/var/storage/internal-ssd/snapshots";
    };
    rsyncBackup.defaults = {
      srcSubvol = "/var/storage/internal-ssd/storage";
      snapshotSubvol = "/var/storage/internal-ssd/snapshots";
      dstSubvol = "/var/storage/external-hdd/backups";
      rsyncPrefix = "rsync";
      snapshotPrefix = "snapshot";
    };
  };

  system.stateVersion = "24.05";

  nix.settings = {
    trusted-users = [
      "root"
      "@wheel"
    ];
  };

  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
      };
      systemd-boot = {
        enable = true;
        configurationLimit = 100;
      };
    };
  };

  networking = {
    useDHCP = true;
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

  fileSystems =
    let
      common_mount_options = [
        "noatime"
        "defaults"
        "compress=zstd"
      ];
    in
    {
      "/var/storage/external-hdd/backups" = {
        device = "/dev/disk/by-label/external-hdd";
        fsType = "btrfs";
        options = [
          "subvol=backups"
        ]
        ++ common_mount_options;
      };
      "/var/storage/external-hdd/snapshots" = {
        device = "/dev/disk/by-label/external-hdd";
        fsType = "btrfs";
        options = [
          "subvol=snapshots"
        ]
        ++ common_mount_options;
      };
      "/var/lib/containers" = {
        device = "/dev/disk/by-label/internal-ssd";
        fsType = "btrfs";
        options = [
          "subvol=containers/system"
        ]
        ++ common_mount_options;
      };
      "/var/storage/internal-ssd/storage" = {
        device = "/dev/disk/by-label/internal-ssd";
        fsType = "btrfs";
        options = [
          "subvol=storage"
        ]
        ++ common_mount_options;
      };
      "/var/storage/internal-ssd/snapshots" = {
        device = "/dev/disk/by-label/internal-ssd";
        fsType = "btrfs";
        options = [
          "subvol=snapshots"
        ]
        ++ common_mount_options;
      };
    };
  # networking.interfaces.enp3s0.useDHCP = lib.mkDefault true;
}
