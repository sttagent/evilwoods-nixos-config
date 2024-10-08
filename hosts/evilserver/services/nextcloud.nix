{
  inputs,
  config,
  pkgs,
  ...
}:
let
  sopsFile = builtins.toString (inputs.evilsecrets + "/secrets/nextcloud.yaml");
in
{
  sops.secrets.admin-pass = {
    inherit sopsFile;
    mode = "0400";
    owner = "nextcloud";
    group = "nextcloud";
  };

  sops.secrets.cloudflared-creds = {
    sopsFile = builtins.toString (inputs.evilsecrets + "/secrets/cloudflared.yaml");
    owner = "cloudflared";
    group = "cloudflared";
    mode = "0600";
  };

  sops.secrets.cloudflared-tunnel-creds = {
    sopsFile = builtins.toString (inputs.evilsecrets + "/secrets/cloudflared.yaml");
    owner = "cloudflared";
    group = "cloudflared";
    mode = "0600";
  };

  services.nextcloud = {
    enable = true;
    https = true;
    package = pkgs.nextcloud29;
    hostName = "localhost";
    home = "/var/storage/internal-ssd/storage/nextcloud";
    database.createLocally = true;
    configureRedis = true;
    caching.redis = true;
    config = {
      adminpassFile = config.sops.secrets.admin-pass.path;
      adminuser = "admin";
      dbtype = "pgsql";
    };
    settings = {
      trusted_domains = [ "nextcloud.evilwoods.net" ];
      trusted_proxies = [ "127.0.0.1" ];
      maintenance_window_start = 1;
      log_type = "file";
    };
    extraAppsEnable = true;
    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps)
        calendar
        tasks
        notes
        contacts
        twofactor_webauthn
        user_oidc
        ;
    };
  };

  services.nginx.virtualHosts.localhost = {
    listen = [
      {
        addr = "127.0.0.1";
        port = 8081;
      }
    ];
  };

  services.caddy.virtualHosts."nextcloud.evilwoods.net" = {
    useACMEHost = "evilwoods.net";
    extraConfig = ''
      encode gzip
      reverse_proxy 127.0.0.1:8081 {
        header_up X-Forwarded-For {remote_host}
        header_up X-Forwarded-Proto {scheme}
        header_up X-Forwarded-host {host}
      }
    '';
  };

  systemd.tmpfiles.rules = [
    "d /var/storage/internal-ssd/storage/nextcloud 0775 nextcloud nextcloud"
  ];

  environment.etc."cloudflared/cert.pem" = {
    source = config.sops.secrets.cloudflared-creds.path;
    user = "cloudflared";
    group = "cloudflared";
    mode = "0600";
  };

  services.cloudflared = {
    enable = true;
    tunnels = {
      "957f3219-6aa5-4672-9d53-2377b59cc308s" = {
        credentialsFile = config.sops.secrets.cloudflared-tunnel-creds.path;
        default = "http_status:404";
        ingress = {
          "nextcloud.evilwoods.net" = "http://127.0.0.1:8081";
        };
      };
    };
  };

  # Backup services
  systemd.services.nextcloud-backup =
    let
      inherit (config.services.nextcloud.config) dbname;
      backupPath = "/var/storage/external-hdd/backups/nextcloud";
      srcPath = "${config.services.nextcloud.home}";
      srcVolume = "/var/storage/internal-ssd/storage";
      snapshotVolume = "/var/storage/internal-ssd/snapshots";

      backupScript = pkgs.writeShellApplication {
        name = "nextcloud-backup";
        runtimeInputs = [
          pkgs.btrfs-progs
          pkgs.coreutils-full
          config.services.postgresql.package
          config.services.nextcloud.package
        ];

        text = ''
          set -euo pipefail

          mkdir -p ${backupPath}/db
          chown nextcloud:nextcloud ${backupPath}
          chmod 700 ${backupPath}

          nextcloud-occ maintenance:mode --on
          sleep 1
          pg_dump ${dbname} | gzip > ${backupPath}/db/nextcloud.sql.gz
          snapshotName="nextcloud-$(date +%Y-%m-%d-%H-%M-%S)"
          btrfs subvolume snapshot -r ${srcVolume} "${snapshotVolume}/$snapshotName"
          nextcloud-occ maintenance:mode --off

          rsync -a "${snapshotVolume}/$snapshotName/nextcloud/data" ${backupPath}/
          btrfs subvolume delete "${snapshotVolume}/$snapshotName"
        '';
      };
    in
    {
      description = "Put nextcloud into maintenance mode and backup the database as well as the data directory";
      serviceConfig = {
        Type = "oneshot";
      };
      script = ''
        ${backupScript}
      '';
    };
}
