{ config, lib, ... }:
let
  inherit (lib) mkForce;
in
{
  evilwoods.podman.enabled = true;

  virtualisation = {
    vmVariant = {
      evilwoods.testEnv.enabled = true;
      evilwoods.vmGuest.enabled = mkForce true;
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
}
