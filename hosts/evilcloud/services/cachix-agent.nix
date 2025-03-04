{ config, ... }:
{
  sops.secrets.evilwoods-agent-token = { };

  services = {
    cachix-agent = {
      enable = true;
      host = "https://evilwoods.cachix.org";
      credentialsFile = config.sops.secrets.evilwoods-agent-token.path;
    };
  };
}
