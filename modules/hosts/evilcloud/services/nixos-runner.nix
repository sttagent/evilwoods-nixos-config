{ inputs, den, ... }:
let
  service-user = "nixos-runner";
  github-runners-dir = "/var/lib/github-runners";
in
{
  den.aspects.services.nixos-runner.nixos =
    { config, ... }:
    {
      systemd.tmpfiles.rules = [
        "d ${github-runners-dir} 0755 root root -"
      ];

      users = {
        users."${service-user}" = {
          isSystemUser = true;
          uid = 1100;
          home = "${github-runners-dir}/${service-user}";
          createHome = true;
          group = "${service-user}";
          useDefaultShell = true;
        };
        groups."${service-user}" = {
          gid = 1100;
        };
      };
      nix.settings.allowed-users = [ "${service-user}" ];
      sops.secrets."nixos-runner" = {
        sopsFile = inputs.evilsecrets + "/secrets/services/nixos-runner.yaml";
        mode = "0600";
        owner = "${service-user}";
        group = "${service-user}";
      };

      services.github-runners.nixos-runner = {
        user = "${service-user}";
        group = "${service-user}";
        enable = true;
        replace = true;
        tokenFile = config.sops.secrets.nixos-runner.path;
        url = "https://github.com/sttagent/evilwoods-nixos-config-private";
        workDir = config.users.users."${service-user}".home;
      };
    };
}
