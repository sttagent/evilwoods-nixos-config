{
  inputs,
  config,
  pkgs,
  ...
}:
let
  inherit (config.evilwoods.host.vars) dataPath;
  inherit (config.evilwoods.vars) domain;
  nextcloudDataPath = "${dataPath}/${appName}";
  appUrl = "${appName}.${domain}";
  appName = "nextcloud";
  sopsFile = builtins.toString (inputs.evilsecrets + "/secrets/nextcloud.yaml");
in
{
  sops.secrets.admin-pass = {
    inherit sopsFile;
    mode = "0400";
    owner = "nextcloud";
    group = "nextcloud";
  };

  services.nextcloud = {
    enable = true;
    https = true;
    package = pkgs.nextcloud31;
    hostName = "localhost";
    home = "${nextcloudDataPath}";
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
      enable_previews = true;
      enabledPreviewProviders = [
        "OC\\Preview\\Movie"
        "OC\\Preview\\PNG"
        "OC\\Preview\\JPEG"
        "OC\\Preview\\GIF"
        "OC\\Preview\\BMP"
        "OC\\Preview\\XBitmap"
        "OC\\Preview\\MP3"
        "OC\\Preview\\MP4"
        "OC\\Preview\\TXT"
        "OC\\Preview\\MarkDown"
        "OC\\Preview\\PDF"
      ];

      simpleSignUpLink.shown = false;
      allow_user_to_change_display_name = false;
      registration.enabled = false;
    };
    autoUpdateApps.enable = true;
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

  services.caddy.virtualHosts.${appUrl} = {
    useACMEHost = appUrl;
    extraConfig = ''
      encode gzip
      reverse_proxy 127.0.0.1:8081 {
        header_up X-Forwarded-For {remote_host}
        header_up X-Forwarded-Proto {scheme}
        header_up X-Forwarded-host {host}
      }
    '';
  };

  security.acme.certs.${appUrl} = {
    domain = appUrl;
    listenHTTP = ":1360";
    reloadServices = [ "caddy.service" ];
  };

  environment.systemPackages = [ pkgs.ffmpeg-headless ];

  systemd.tmpfiles.rules = [
    "d ${nextcloudDataPath} 0775 nextcloud nextcloud"
  ];

}
