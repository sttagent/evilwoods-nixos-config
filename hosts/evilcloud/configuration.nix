{
  inputs,
  configPath,
  ...
}:
{
  imports = [
    inputs.sops-nix-2411.nixosModules.sops
    inputs.home-manager-2411.nixosModules.home-manager
  ];

  evilwoods.config.vmGuest.enable = true;

  system.stateVersion = "24.11";

  nix.settings = {
    trusted-users = [
      "root"
      "@wheel"
    ];
  };

  networking = {
    nftables.enable = true;
    useDHCP = true;
  };

  virtualisation = {
    oci-containers = {
      backend = "podman";
    };
  };
  # networking.interfaces.enp3s0.useDHCP = lib.mkDefault true;
}
