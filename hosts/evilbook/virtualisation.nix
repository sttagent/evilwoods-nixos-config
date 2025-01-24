{ pkgs, config, ... }:
let
  inherit (config.evilwoods.vars) mainUser;
in
{
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

    podman = {
      enable = true;
    };
  };

  networking.firewall.trustedInterfaces = [ "virbr0" ];

  programs.virt-manager.enable = true;

  users.users.${mainUser} = {
    extraGroups = [ "libvirtd" ];
  };

}
