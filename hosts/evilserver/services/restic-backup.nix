{ config, pkgs, ... }:
let
  snapshotPath = "/var/ext-hdd-snapshots";
in
{
  fileSystems."${snapshotPath}" = {
    device = "/dev/disk/by-label/External-backup";
    fsType = "btrfs";
    options = [
      "defaults"
      "noatime"
      "compress=zstd"
      "subvol=/snapshots"
    ];
  };
  systemd.tmpfiles.rules = [ "d ${snapshotPath} 0700 root root" ];
  sops.secrets = {
    "evilserver-restic-backup.env".mode = "0400";
    "evilserver-restic-backup-repo".mode = "0400";
    "evilserver-restic-backup-repo-pass".mode = "0400";
  };
  services.restic.backups = {
    ext-hdd-backblaze = {
      initialize = true;
      environmentFile = config.sops.secrets."evilserver-restic-backup.env".path;
      timerConfig = {
        OnCalendar = "04:30";
        Persistent = true;
      };
      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 5"
        "--keep-monthly 12"
        "--keep-yearly 10"
      ];
      paths = [ snapshotPath ];
      repositoryFile = config.sops.secrets."evilserver-restic-backup-repo".path;
      passwordFile = config.sops.secrets."evilserver-restic-backup-repo-pass".path;
      backupPrepareCommand = ''
        ${pkgs.btrfs-progs}/bin/btrfs subvolume snapshot -r /var/backups ${snapshotPath} && \
        ${pkgs.btrfs-progs}/bin/btrfs subvolume snapshot -r /home/aitvaras/share ${snapshotPath}/aitvaras-share && \
        ${pkgs.btrfs-progs}/bin/btrfs subvolume snapshot -r /home/ryne/share ${snapshotPath}/ryne-share && \
        ${pkgs.btrfs-progs}/bin/btrfs subvolume snapshot -r /home/samba-guest/share ${snapshotPath}/samba-guest-share
      '';
      backupCleanupCommand = ''
        ${pkgs.btrfs-progs}/bin/btrfs subvolume delete ${snapshotPath}/*
      '';
    };
  };
}
