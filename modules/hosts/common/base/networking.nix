{
  flake.modules.nixos.base = {
    services.firewalld.enable = true;
    networking.nftables.enable = true;
  };
}
