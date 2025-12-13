{ config, lib, ... }:
let
  inherit (lib) mkForce;
in
{
  virtualisation.vmVariant = {
    evilwoods = {
      testEnv.enabled = mkForce true;
      vmGuest.enabled = mkForce true;
    };
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
}
