{ config, lib, ... }:
let
  inherit (lib) mkForce;
in
{
  virtualisation.vmVariant = {
    evilwoods.vars.isTestEnv = true;
    networking.hostName = mkForce "${config.networking.hostName}-test";
    virtualisation = {
      memorySize = 1024 * 4;
      cores = 2;
      sharedDirectories = {
        sshKeys = {
          source = "/home/aitvaras/.config/evilwoods/ssh_keys/evilbook";
          target = "/etc/ssh";
        };
      };
    };
  };
}
