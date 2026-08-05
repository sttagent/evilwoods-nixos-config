{
  den.aspects.virtualisation.qemu.nixos = { pkgs, ... }: {
    virtualisation = {
      libvirtd = {
        enable = true;
        qemu = {
          package = pkgs.qemu_kvm;
        };
      };
    };
    networking.firewall.trustedInterfaces = [ "virbr0" ];
    programs.virt-manager.enable = true;
  };
}
