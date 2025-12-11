{ inputs, config, ... }:
let
  secretsPath = builtins.toString inputs.evilsecrets;
in
{
  sops.secrets.evilwoods-agent-token = {
    sopsFile = "${secretsPath}/secrets/aitvaras/default.yaml";
  };

  services = {
    cachix-agent = {
      enable = true;
      credentialsFile = config.sops.secrets.evilwoods-agent-token.path;
    };
  };
}
