{ config, pkgs, ... }:
let
  inherit (config.services.postgresql.package) psqlSchema;
  psqlDataDir = "/var/storage/internal-ssd/storage/postgresql";
in
{
  systemd.tmpfiles.rules = [
    "d ${psqlDataDir} 0750 postgres postgres"
    "d ${psqlDataDir}/${psqlSchema} 0750 postgres postgres"
  ];

  services = {
    postgresql = {
      enable = true;
      dataDir = "${psqlDataDir}/${psqlSchema}";
    };
    postgresqlBackup = {
      enable = true;
      location = "/var/storage/external-hdd/backups/postgresql";
    };
  };
}
