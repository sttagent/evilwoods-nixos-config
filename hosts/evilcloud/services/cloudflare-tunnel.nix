{ inputs, config, ... }:
{
  sops.secrets.cloudflared-evilcloud-tunnel-cert = {
    sopsFile = builtins.toString (inputs.evilsecrets + "/secrets/cloudflared.yaml");
    owner = "cloudflared";
    group = "cloudflared";
    mode = "0600";
  };

  sops.secrets.cloudflared-evilcloud-tunnel-id = {
    sopsFile = builtins.toString (inputs.evilsecrets + "/secrets/cloudflared.yaml");
    owner = "cloudflared";
    group = "cloudflared";
    mode = "0600";
  };

  services.cloudflared = {
    enable = true;
    tunnels = {
      "5c5360ae-6911-41e2-bbcb-b5b78954349c" = {
        credentialsFile = config.sops.secrets.cloudflared-evilcloud-tunnel-id.path;
        default = "http_status:404";
      };
    };
  };

  environment.etc."cloudflared/cert.pem" = {
    source = config.sops.secrets.cloudflared-evilcloud-tunnel-cert.path;
    user = config.services.cloudflared.user;
    group = config.services.cloudflared.group;
    mode = "0600";
  };
}
