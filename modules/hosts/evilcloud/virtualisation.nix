{ ... }:
{
  flake.modules.nixos.hostEvilcloud =
    { config, lib, ... }:
    let
      inherit (lib) mkForce;
    in
    {
      evilwoods.podman.enabled = true;

      virtualisation = {
        podman = {
          dockerSocket.enable = true;
          defaultNetwork.settings = {
            dns_enabled = true;
          };
        };
        incus = {
          enable = true;
        };

        vmVariant = {
          evilwoods.testEnv.enabled = true;
          networking.hostName = mkForce "${config.networking.hostName}-vm-test";
          virtualisation = {
            memorySize = 1024 * 4;
            cores = 2;
            sharedDirectories = {
              sshKeys = {
                source = "/home/aitvaras/.config/evilwoods/ssh_keys/evilcloud/etc/ssh";
                target = "/etc/ssh";
              };
            };
          };
        };
      };
    };
}
