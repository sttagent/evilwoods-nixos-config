{
  inputs,
  ...
}:
{
  imports = [
    inputs.sops-nix-stable.nixosModules.sops
    inputs.home-manager-stable.nixosModules.home-manager
  ];

  evilwoods = {
    flags = {
      role = "server";
    };
  };

  system.stateVersion = "25.11";

  services.openssh = {
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  boot = {
    loader = {
      # efi = {
      #   canTouchEfiVariables = true;
      # };
      # systemd-boot = {
      #   enable = true;
      #   configurationLimit = 10;
      # };
      grub = {
        enable = true;
        device = "/dev/sda";
        efiSupport = true;
        efiInstallAsRemovable = true;
      };
    };
  };

  # networking.interfaces.enp3s0.useDHCP = lib.mkDefault true;
}
