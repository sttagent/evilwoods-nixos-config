{ pkgs, config, ... }:
let
  inherit (config.evilwoods.vars) mainUser;
in
{
  evilwoods.config.podman.enable = true;

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
      };
    };

    vmVariant = {
      virtualisation = {
        memorySize = 4096;
        cores = 2;
      };
    };

  };

  networking.firewall.trustedInterfaces = [ "virbr0" ];

  programs.virt-manager.enable = true;

  users.users.${mainUser} = {
    extraGroups = [ "libvirtd" ];
  };

}
