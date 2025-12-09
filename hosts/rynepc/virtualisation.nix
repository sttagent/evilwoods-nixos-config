{ config, lib, ... }:
let
  inherit (lib) mkForce;
in
{
  virtualisation.vmVariant = {
    evilwoods = {
      flags.isTestEnv = mkForce true;
      config.vmGuest.enabled = mkForce true;
    };
    networking.hostName = mkForce "${config.networking.hostName}-test";
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
