{ config, pkgs, ... }:
{
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud29;
    hostName = "localhost";
    home = "/var/storage/internal-ssd/storage/nextcloud";
    database.createLocally = true;
    config = {
      adminpassFile = "/etc/nextcloud/adminPassword";
      dbtype = "pgsql";
    };
    settings.trusted_domains = [ "nextcloud.evilwoods.net" ];
    extraAppsEnable = true;
    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps) calendar;
    };
  };

  services.nginx.virtualHosts.localhost.listen = [
    {
      addr = "127.0.0.1";
      port = 8080;
    }
  ];

  systemd.tmpfiles.rules = [
    "d /var/storage/internal-ssd/storage/nextcloud 0775 nextcloud nextcloud"
  ];

  environment.etc."nextcloud/adminPassword" = {
    text = ''
      password
    '';
    user = "nextcloud";
    group = "nextcloud";
    mode = "0440";
  };
}
