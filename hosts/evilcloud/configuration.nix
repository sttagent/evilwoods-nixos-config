{
  inputs,
  configPath,
  ...
}:
{
  imports = [
    (configPath + "/common/")
    (configPath + "/hardware/boot/systemd-boot.nix")
    (configPath + "/server")

    inputs.sops-nix-2405.nixosModules.sops
    inputs.home-manager-2405.nixosModules.home-manager

    # Services
    (configPath + "/services/adguard.nix")
  ];

  system.stateVersion = "24.05";

  nix.settings = {
    trusted-users = [
      "root"
      "@wheel"
    ];
  };

  networking = {
    nftables.enable = true;
    useDHCP = false;
    defaultGateway = "192.168.1.1";
    interfaces.enp6s18 = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "192.168.1.3";
          prefixLength = 24;
        }
      ];
    };
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGFc8oFtu7i4WBlbcDMB7ua9cHJW2bzeomrLFddokw7v aitvaras@evilbook"
  ];

  # networking.interfaces.enp3s0.useDHCP = lib.mkDefault true;
}
