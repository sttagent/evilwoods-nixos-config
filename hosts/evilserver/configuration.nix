{
  config,
  lib,
  pkgs,
  ...
}:
{
  nix.settings = {
    trusted-users = [
      "root"
      "@wheel"
    ];
  };

  programs.nix-ld = {
    enable = true;
  };

  systemd.tmpfiles.rules = [ "d /var/storage/docker 0700 root root" ];
  virtualisation = {
    oci-containers = {
      backend = "docker";
    };
    docker = {
      enable = true;
      storageDriver = "btrfs";
      daemon.settings = {
        data-root = "/var/storage/docker";
      };
      autoPrune = {
        enable = true;
        flags = [ "--all" ];
      };
    };
  };

  fileSystems = {
    "/var/backups" = {
      device = "/dev/disk/by-label/External-backup";
      fsType = "btrfs";
      options = [
        "defaults"
        "noatime"
        "compress=zstd"
      ];
    };
  };

  evilwoods = {
    rsyncBackup.defaults = {
      srcSubvol = "/var/storage";
      snapshotSubvol = "/var/snapshots";
      dstSubvol = "/var/backups";
      rsyncPrefix = "rsync";
      snapshotPrefix = "snapshot";
    };
  };

  # networking.interfaces.enp3s0.useDHCP = lib.mkDefault true;
}
