{ pkgs, ... }:
let
  appName = "kitchenowl-app";
  appVolume = "kitchenowl_data";
  dockeServiceName = "docker-${appName}";
  rsyncServiceName = "rsync-${appName}";
  snapshotServiceName = "snapshot-${appName}";
  srcPath = "/var/snapshots/${appName}/docker/volumes/${appVolume}";
  dstPath = "/var/backups/docker/volumes/${appVolume}";
in {
  virtualisation.oci-containers.containers = {
    ${appName} = {
      autoStart = true;
      image = "docker.io/tombursch/kitchenowl:v0.5.2";
      ports = [ "8081:8080" ];
      environment = {
        JWT_SECRET_KEY = "satan_spawn";
      };
      volumes = [
        "${appVolume}:/data"
      ];
    };
  };

  systemd.timers."${snapshotServiceName}" = {
    enable = true;
    description = "${appName} backup timer";
    wantedBy = [ "multi-user.target" ];
    timerConfig = {
      OnCalendar = "daily";
      AccuracySec = "1s";
      RandomizedDelaySec = "5h";
    };

  };

  systemd.services."${snapshotServiceName}" = {
    enable = true;
    description = "Take btrfs snapshot of storage subvol";
    conflicts = [ "${dockeServiceName}.service" ];
    after = [ "${dockeServiceName}.service" ];
    onSuccess = [
      "${dockeServiceName}.service"
      "${rsyncServiceName}.service"
    ];
    onFailure = [
      "${dockeServiceName}.service"
    ];
    unitConfig = {
      RequiresMountsFor = "/var/storage /var/snapshots";
    };
    script = ''
      snapshot="${appName}-$(${pkgs.coreutils-full}/bin/date +%F-%H-%M-%S)" && \
      ${pkgs.btrfs-progs}/bin/btrfs subvolume snapshot -r /var/storage /var/snapshots/$snapshot && \
      ln -s /var/snapshots/$snapshot /var/snapshots/${appName}
    '';
  };

  systemd.services."${rsyncServiceName}" = {
    enable = true;
    description = "Syncs ${appName} data to backup drive.";
    unitConfig = {
      RequiresMountsFor = "/var/snapshots /var/backups";
    };
    script = ''
      mkdir -p ${dstPath} && \
      chmod 700 ${dstPath} && \
      ${pkgs.rsync}/bin/rsync -a ${srcPath}/ ${dstPath} --delete
    '';
    postStop = ''
      rm /var/snapshots/${appName}
      ${pkgs.btrfs-progs}/bin/btrfs subvolume delete /var/snapshots/${appName}-*
    '';
  };

}
