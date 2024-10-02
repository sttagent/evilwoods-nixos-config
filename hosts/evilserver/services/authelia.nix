{
  inputs,
  config,
  lib,
  ...
}:
let
  inherit (lib) genAttrs;
  sopsFile = builtins.toString (inputs.evilsecrets + "/secrets/authelia.yaml");
  instanceName = "evilwoods";
  dataPath = "/var/storage/internal-ssd/storage/authelia";
  pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages.x86_64-linux;

  genAutheliaSecrets =
    secretList:
    genAttrs secretList (secret: {
      mode = "0440";
      owner = config.users.users."authelia-${instanceName}".name;
      group = config.users.users."authelia-${instanceName}".group;
      inherit sopsFile;
    });
in
{
  sops.secrets = genAutheliaSecrets [
    "authelia-encryption-key"
    "authelia-jwtsecret"
    "authelia-oidc-issuer-private-key"
    "authelia-oidc-hmac-secret"
    "kitchenowl-oidc-client-id"
    "kitchenowl-oidc-client-secret-hash"
  ];

  systemd.tmpfiles.rules = [ "d ${dataPath} 0775 authelia-${instanceName} authelia-${instanceName}" ];

  services.authelia.instances.${instanceName} = {
    enable = true;
    package = pkgs-unstable.authelia;
    secrets = {
      storageEncryptionKeyFile = config.sops.secrets.authelia-encryption-key.path;
      jwtSecretFile = config.sops.secrets.authelia-jwtsecret.path;
      oidcIssuerPrivateKeyFile = config.sops.secrets.authelia-oidc-issuer-private-key.path;
    };

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
      identity_providers.oidc = {
        cors = {
          allowed_origins = [ "https://evilwoods.net" ];
        };
        clients = [
          {
            client_name = "kitchenowl";
            client_id = "o4D8yI0GB8GLNuM6ztuEQUaq2akyxWst_knlRIOkoL1J0r4Zz9WJokmKb2X4AM0MMCZnho~x";
            client_secret = "$pbkdf2-sha512$310000$u1DPeSCLJGCG8Z7bTfe23g$Bskdf6n188NAG/wmJtaSo/vr0hg9VTvpsiNvLtg8txRI2Mr29hYJtZpTFbZL.JZvfEQ2wZjK2T8twt1gCmxH7g";
            authorization_policy = "one_factor";
            audience = [ ];
            scopes = [
              "openid"
              "profile"
              "email"
            ];
            redirect_uris = [
              "https://kitchenowl.evilwoods.net/signin/redirect"
              "kitchenowl:///signin/redirect"
            ];
            userinfo_signing_algorithm = "none";
            token_endpoint_auth_method = "client_secret_post";
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

  # Gives permission to the service to write to the custom dataPath because
  # access to the system is restricted to the generated service by the module.
  systemd.services."authelia-${instanceName}".serviceConfig = {
    ReadWritePaths = [ "${dataPath}" ];
  };

  environment.etc."authelia/users_database.yml" = {
    mode = "0440";
    user = "authelia-${instanceName}";
    group = "authelia-${instanceName}";
    text = ''
      users:
        aitvaras:
          disabled: false
          displayname: Aitvaras
          password: $argon2id$v=19$m=65536,t=3,p=4$ke3atIARCiBqZJ3S6BJ+xg$FyRnBXOjKPxuebyw08nDl9jBkpoBpYQwIZgk0yMzv/8
          email: sttagent@evilwoods.net
          groups:
            - admin
            - dev
        ryne:
          disabled: false
          displayname: Ryne
          password: $argon2id$v=19$m=65536,t=3,p=4$5hjWzwvGzfXIXW+ow8F25g$pXbvlkAbOzNzVZO2qPtuQeNgn/9zlGMbS6+vGSuD8h8
          email: zaren@evilwoods.net
          groups:
    '';
  };
}
