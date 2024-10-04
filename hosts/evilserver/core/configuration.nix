{ inputs, configPath, ... }:
{
  imports = [
    (configPath + "/core")
    (configPath + "/hardware/boot/systemd-boot.nix")

    inputs.disko-2405.nixosModules.disko
  ];
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGFc8oFtu7i4WBlbcDMB7ua9cHJW2bzeomrLFddokw7v aitvaras@evilbook"
  ];

  networking = {
    useDHCP = false;
    defaultGateway = "192.168.1.1";
    interfaces.enp2s0 = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "192.168.1.2";
          prefixLength = 24;
        }
      ];
    };
  };

  system.stateVersion = "24.05";
}
