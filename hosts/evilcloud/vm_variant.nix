# The file is not imported by default

{ config, lib, ... }:
let
  inherit (lib) mkForce;
in
{
  virtualisation.vmVariant = {
    evilwoods.testEnv.enabled = true;
    networking.hostName = mkForce "${config.networking.hostName}-test";
    virtualisation = {
      memorySize = 1024 * 4;
      cores = 2;
      sharedDirectories = {
        sshKeys = {
          source = "/home/aitvaras/.config/evilwoods/ssh_keys/evilcloud";
          target = "/etc/ssh";
        };
      };
    };
  };
}
