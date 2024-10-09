{
  inputs,
  config,
  pkgs,
  ...
}:
let
  sopsFile = builtins.toString (inputs.evilsecrets + "/secrets/nextcloud.yaml");
  backupServiceName = "nextcloud-backup";
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
    package = pkgs.nextcloud30;
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
  systemd.services."${backupServiceName}" =
    let
      inherit (config.services.nextcloud.config) dbname;

      pgsqlUser = "postgres";

      backupScripsName = "nextcloud-backup";
      postBackupScriptName = "post-${backupScripsName}";
      preBackupScriptName = "pre-${backupScripsName}";
      backupPath = "/var/storage/external-hdd/backups/nextcloud";
      srcPath = "${config.services.nextcloud.home}";
      srcVolume = "/var/storage/internal-ssd/storage";
      snapshotVolume = "/var/storage/internal-ssd/snapshots";

      backupScript = pkgs.writeShellApplication {
        name = backupScripsName;
        runtimeInputs = [
          pkgs.btrfs-progs
          pkgs.coreutils-full
          pkgs.gzip
          pkgs.rsync
          config.services.postgresql.package
          config.services.nextcloud.occ
        ];

        text = ''
          sleep 1
          mkdir -p ${backupPath}/db
          chown nextcloud:nextcloud ${backupPath}
          chmod 700 ${backupPath}

          /run/wrappers/bin/sudo -u ${pgsqlUser} pg_dump ${dbname} | gzip > ${backupPath}/db/nextcloud.sql.gz

          snapshotName="nextcloud-$(date +%Y-%m-%d-%H-%M-%S)"
          btrfs subvolume snapshot -r ${srcVolume} "${snapshotVolume}/$snapshotName"
          nextcloud-occ maintenance:mode --off

          rsync -a --delete "${snapshotVolume}/$snapshotName/nextcloud/data" ${backupPath}/
        '';
      };

      postBackupScript = pkgs.writeShellApplication {
        name = postBackupScriptName;
        runtimeInputs = [
          pkgs.btrfs-progs
          config.services.nextcloud.occ
        ];
        text = ''
          nextcloud-occ maintenance:mode --off
          btrfs subvolume delete ${snapshotVolume}/nextcloud-*
        '';
      };

      preBackupScript = pkgs.writeShellApplication {
        name = preBackupScriptName;
        runtimeInputs = [
          config.services.nextcloud.occ
        ];
        text = ''
          nextcloud-occ maintenance:mode --on
        '';
      };
    in
    {
      enable = true;
      description = "Put nextcloud into maintenance mode and backup the database as well as the data directory";
      path = [
        backupScript
        postBackupScript
        preBackupScript
      ];
      serviceConfig = {
        Type = "oneshot";
      };
      preStart = ''
        ${preBackupScriptName}
      '';
      script = ''
        ${backupScripsName}
      '';
      postStop = ''
        ${postBackupScriptName}
      '';
    };

    };
}
