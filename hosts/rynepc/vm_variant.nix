# The file is not imported by default

{ config, lib, ... }:
let
  inherit (lib) mkForce;
in
{
  virtualisation.vmVariant = {
    evilwoods.vars.isTestEnv = mkForce true;
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
