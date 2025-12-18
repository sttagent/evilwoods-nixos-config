{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkForce;
  inherit (config.evilwoods.base) mainUser;
in
{
  evilwoods.podman.enabled = true;

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
      };
    };

    vmVariant = {
      evilwoods.testEnv.enabled = true;
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
  };

  networking.firewall.trustedInterfaces = [ "virbr0" ];

  programs.virt-manager.enable = true;

  users.users.${mainUser} = {
    extraGroups = [ "libvirtd" ];
  };

}
