{
  inputs,
  ...
}:
{
  flake.modules.nixos.serviceForgejoRunner =
    {
      config,
      pkgs,
      ...
    }:
    let
      secretsPath = toString inputs.evilsecrets;
    in
    {
      sops.secrets.forgejo-runner-token = {
        sopsFile = secretsPath + "/secrets/evilcloud/default.yaml";
      };
      services = {
        gitea-actions-runner = {
          package = pkgs.forgejo-runner;
          instances.codeberg = {
            enable = true;
            name = "evilwoods-codeberg-runner";
            tokenFile = config.sops.secrets.forgejo-runner-token.path;
            url = "https://codeberg.org";
            labels = [
              "nixos-latest:docker://nixos/nix"
            ];
            settings = { };
          };
        };
      };
    };
}
