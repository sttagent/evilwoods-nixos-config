{
  services = {
    postgresql = {
      enable = true;
    };
    postgresqlBackup = {
      enable = true;
      location = "/var/backups/postgresql";
    };
  };
}
