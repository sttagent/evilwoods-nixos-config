{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.evilwoods.rsyncBackup;
  defaults = config.evilwoods.rsyncBackup.defaults;
in
{
  options.evilwoods.rsyncBackup = with lib; {
    defaults = {

      srcSubvol = mkOption {
        description = ''
          Path to  source subvolume
        '';
        type = types.nullOr types.str;
        default = null;
        example = "/var/storage";
      };

      snapshotSubvol = mkOption {
        description = ''
          Path to snapshot subvolume
        '';
        type = types.nullOr types.str;
        default = null;
        example = "/var/snapshots";
      };

      dstSubvol = mkOption {
        description = ''
          Path where backups subvolume is mounted
        '';
        type = types.nullOr types.str;
        default = null;
        example = "/var/backups";
      };
      rsyncPrefix = mkOption {
        description = ''
          Prefix to be added to rsync service file name.
        '';
        type = types.str;
        default = "";
        example = "rsync";
      };
      snapshotPrefix = mkOption {
        description = ''
          Prefix to be added to snapshot service file name.
        '';
        type = types.str;
        default = "";
        example = "snapshot";
      };
    };

    backups = mkOption {
      description = ''
        Periodic sync of folders with rsync and btrfs snapshot as source
      '';
      default = { };
      type = types.attrsOf (
        types.submodule (
          { name, ... }:
          {
            options = {

              appName = mkOption {
                description = ''
                  Sevice name
                '';
                type = types.nullOr types.str;
                default = name;
                example = "example-app";
              };

              unitFileName = mkOption {
                description = ''
                  The file name of sevire unit file to stop and restart.
                '';
                type = types.nullOr types.str;
                default = null;
                example = "docker-example-app.service";
              };

              srcPath = mkOption {
                description = ''
                  Path to source forlder to be synced
                '';
                type = types.nullOr types.str;
                default = null;
                example = "/var/storage/app/data";
              };

              dstPath = mkOption {
                description = ''
                  Path to destination forlder to be synced to.
                '';
                type = types.nullOr types.str;
                default = null;
                example = "/var/backups/app/data";
              };
              snapshotPath = mkOption {
                description = ''
                  Path to snapshoted forlder to be synced to.
                '';
                type = types.nullOr types.str;
                default = null;
                example = "/var/snapshots/app/data";
              };
            };
          }
        )
      );
    };
  };

  config = {
    assertions = lib.mapAttrsToList (name: value: {
      assertion =
        !(
          (value.srcPath == null)
          || (value.dstPath == null)
          || (value.snapshotPath == null)
          || (value.unitFileName == null)
        );
      message = "all backup options need to be set.";
    }) cfg.backups;

    systemd.timers = lib.mapAttrs' (
      backupName: backupConfig:
      lib.nameValuePair "${defaults.snapshotPrefix}-${backupConfig.appName}" {
        enable = true;
        description = "${backupConfig.appName} backup timer";
        timerConfig = {
          OnCalendar = "daily";
          AccuracySec = "1s";
          RandomizedDelaySec = "4h";
        };
      }
    ) cfg.backups;

    systemd.services =
      let
        mkSnapshotServices =
          backupName: backupConfig:
          lib.nameValuePair "${defaults.snapshotPrefix}-${backupConfig.appName}" {
            enable = true;
            description = "Stops ${backupConfig.appName} service and takes btrfs snapshot.";
            conflicts = [ "${backupConfig.unitFileName}" ];
            after = [ "${backupConfig.unitFileName}" ];
            onSuccess = [
              "${backupConfig.unitFileName}"
              "${defaults.rsyncPrefix}-${backupConfig.appName}.service"
            ];
            onFailure = [ "${backupConfig.unitFileName}" ];
            unitConfig = {
              RequiresMountsFor = "${defaults.snapshotSubvol} ${defaults.srcSubvol}";
            };
            script = ''
              snapshot="${backupConfig.appName}-$(${pkgs.coreutils-full}/bin/date +%F-%H-%M-%S)" && \
              ${pkgs.btrfs-progs}/bin/btrfs subvolume snapshot -r ${defaults.srcSubvol} ${defaults.snapshotSubvol}/$snapshot && \
              ln -s ${defaults.snapshotSubvol}/$snapshot ${defaults.snapshotSubvol}/${backupConfig.appName}
            '';
          };

        mkRsyncServices =
          backupName: backupConfig:
          lib.nameValuePair "${defaults.rsyncPrefix}-${backupConfig.appName}" {
            enable = true;
            description = "Syncs ${backupName} data to backup drive";
            unitConfig = {
              RequiresMountsFor = "${defaults.snapshotSubvol} ${defaults.dstSubvol}";
            };
            script = ''
              mkdir -p ${backupConfig.dstPath} && \
              chmod 700 ${backupConfig.dstPath} && \
              ${pkgs.rsync}/bin/rsync -a ${backupConfig.snapshotPath}/ ${backupConfig.dstPath} --delete
            '';
            postStop = ''
              rm ${defaults.snapshotSubvol}/${backupConfig.appName}
              ${pkgs.btrfs-progs}/bin/btrfs subvolume delete ${defaults.snapshotSubvol}/${backupConfig.appName}-*
            '';
          };

        mkServicesWith = f: lib.mapAttrs' f cfg.backups;
      in
      (mkServicesWith mkSnapshotServices) // (mkServicesWith mkRsyncServices);
  };
}
