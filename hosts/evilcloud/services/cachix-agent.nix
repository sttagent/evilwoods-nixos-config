{ config, ... }:
{
  sops.secrets.evilwoods-agent-token = { };

  services = {
    cachix-agent = {
      enable = true;
      credentialsFile = config.sops.secrets.evilwoods-agent-token.path;
    };
  };
}
