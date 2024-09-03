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

  services.qemuGuest.enable = true;
  
  networking = {
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
  
  system.stateVersion = "24.05";
}
