{
  inputs,
  config,
  lib,
  ...
}:
let
  inherit (builtins) head;
  inherit (lib) genAttrs splitString;
  inherit (config.evilwoods.vars) domain;
  inherit (config.evilwoods.host.vars) dataPath;

  sopsFile = builtins.toString (inputs.evilsecrets + "/secrets/aitvaras/authelia.yaml");
  instanceName = domain |> splitString "." |> head;
  finalInstanceName = "authelia-${instanceName}";
  autheliaDataPath = "${dataPath}/${finalInstanceName}";
  url = "auth.${domain}";

  listenHTTPPort = "1360";

  genAutheliaSecrets =
    secretList:
    genAttrs secretList (secret: {
      mode = "0440";
      # TODO: Figure out why this doesn't work. The instance is not available
      # at the time of the generation of this file.
      # owner = config.services.authelia.instances."${finalInstanceName}".user;
      # group = config.services.authelia.instances."${finalInstanceName}".group;
      owner = finalInstanceName;
      group = finalInstanceName;
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

  systemd.tmpfiles.rules = [
    "d ${autheliaDataPath} 0775 ${finalInstanceName} ${finalInstanceName}"
  ];

  services.authelia.instances.${instanceName} = {
    enable = true;
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
            domain = "*.${domain}";
            policy = "one_factor";
          }
        ];

      };
      identity_providers.oidc = {
        cors = {
          allowed_origins = [ "https://${domain}" ];
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
            domain = "${domain}";
            authelia_url = "https://${url}";
          }
        ];
      };
      storage.local.path = "${autheliaDataPath}/db.sqlite3";
      notifier.filesystem.filename = "${autheliaDataPath}/notifications.txt";
      server.endpoints.authz.forward-auth.implementation = "ForwardAuth";
    };
  };

  # Gives permission to the service to write to the custom dataPath because
  # access to the system is restricted to the generated service by the module.
  systemd.services."${finalInstanceName}".serviceConfig = {
    ReadWritePaths = [ "${autheliaDataPath}" ];
  };

  environment.etc."authelia/users_database.yml" = {
    mode = "0440";
    # TODO: Figure out why this doesn't work. The instance is not available
    # at the time of the generation of this file.
    # user = config.services.authelia.instances."${finalInstanceName}".user;
    # group = config.services.authelia.instances."${finalInstanceName}".group;
    user = finalInstanceName;
    group = finalInstanceName;
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

  services.caddy.virtualHosts."${url}" = {
    useACMEHost = "${url}";
    extraConfig = ''
      reverse_proxy 127.0.0.1:9091
    '';
  };

  security.acme.certs."${url}" = {
    domain = "${url}";
    listenHTTP = ":${listenHTTPPort}";
    reloadServices = [ "caddy.service" ];
  };
}
