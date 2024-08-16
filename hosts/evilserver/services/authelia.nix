{ inputs, config, ... }:
let
  instanceName = "evilwoods";
  dataPath = "/var/storage/authelia";
  pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages.x86_64-linux;
in
{
  sops.secrets.authelia-encryption-key = {
    mode = "0440";
    owner = config.users.users."authelia-${instanceName}".name;
    group = config.users.users."authelia-${instanceName}".group;
  };

  sops.secrets.authelia-jwtsecret = {
    mode = "0440";
    owner = config.users.users."authelia-${instanceName}".name;
    group = config.users.users."authelia-${instanceName}".group;
  };

  systemd.tmpfiles.rules = [ "d ${dataPath} 0775 authelia-${instanceName} authelia-${instanceName}" ];

  services.authelia.instances.${instanceName} = {
    enable = true;
    package = pkgs-unstable.authelia;
    secrets.storageEncryptionKeyFile = config.sops.secrets.authelia-encryption-key.path;
    secrets.jwtSecretFile = config.sops.secrets.authelia-jwtsecret.path;
    settings = {
      authentication_backend.file.path = "/etc/authelia/users_database.yml";
      access_control = {
        default_policy = "deny";
        rules = [
          {
            domain = "*.evilwoods.net";
            policy = "one_factor";
          }
        ];
      };
      session = {
        cookies = [
          {
            domain = "evilwoods.net";
            authelia_url = "https://auth.evilwoods.net";
          }
        ];
      };
      storage.local.path = "${dataPath}/db.sqlite3";
      notifier.filesystem.filename = "${dataPath}/notifications.txt";
      server.endpoints.authz.forward-auth.implementation = "ForwardAuth";
    };
  };

  systemd.services."authelia-${instanceName}".serviceConfig = {
    ReadWritePaths = [ "${dataPath}" ];
  };

  environment.etc."authelia/users_database.yml" = {
    mode = "0440";
    user = "authelia-${instanceName}";
    group = "authelia-${instanceName}";
    text = ''
      users:
        bob:
          disabled: false
          displayname: bob
          # password of password
          password: $argon2id$v=19$m=65536,t=3,p=4$2ohUAfh9yetl+utr4tLcCQ$AsXx0VlwjvNnCsa70u4HKZvFkC8Gwajr2pHGKcND/xs
          email: bob@jim.com
          groups:
            - admin
            - dev
    '';
  };
}
