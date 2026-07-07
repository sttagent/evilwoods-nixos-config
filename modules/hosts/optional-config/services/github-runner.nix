{ inputs, ... }: {
  den.aspects.services.nixos-runner.nixos =
    { config, ... }:
    {
      sops.secrets."nixos-runner" = {
        sopsFile = inputs.evilsecrets + "/secrets/services/nixos-runner.yaml";
        mode = "0600";
        owner = "root";
        group = "root";
      };

      services.github-runners.nixos-runner = {
        enable = true;
        replace = true;
        tokenFile = config.sops.secrets.nixos-runner.path;
        url = "https://github.com/sttagent/evilwoods-nixos-config-private";
      };
    };
}
