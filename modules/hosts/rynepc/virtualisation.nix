{ self, ... }:
{
  flake.modules.nixos.hostRynepc =
    { config, lib, ... }:
    let
      inherit (lib) mkForce;
    in
    {
      options.evilwoods.variables.vmGuest = lib.mkEnableOption "Is host a vm guest?";
      config = {
        virtualisation.vmVariant = {
          evilwoods = {
            testEnv.enabled = mkForce true;
          };
          imports = [
            self.modules.nixos.vmGuest
          ];
          networking.hostName = mkForce "${config.networking.hostName}-vm-test";
          virtualisation = {
            memorySize = 1024 * 4;
            cores = 4;
            sharedDirectories = {
              sshKeys = {
                source = "/home/aitvaras/.config/evilwoods/ssh_keys/rynepc";
                target = "/etc/ssh";
              };
            };
          };
        };
      };
    };
}
